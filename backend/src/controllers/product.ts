/**
 * Currently these operations can only be performed by user with a
 * seller role
 */

import { IncomingForm } from "formidable";
import { deleteFileInFirebaseStorage } from "../firebase";
import {
  createProductFormCallback,
  updateProductFormCallback,
} from "../helpers/product";
import Product, { ProductDocument } from "../models/product";
import ProductOrder from "../models/product_order";
import { Controller, responseMsg, runAsync } from "../utils";
import { createPaymentIntentAndCharge } from "../payments/payment";
import MongoPaging from "mongo-cursor-pagination";

/**
 * Create product
 *
 * @remarks
 *
 * Shape of req.body
 * - title
 * - description
 * - info
 * - price
 * - tags
 * - quantityLeft
 * - coverImgs - array of img files which displays product
 */
export const createProduct: Controller = async (req, res) => {
  let form = new IncomingForm({ keepExtensions: true, multiples: true });
  form.parse(req, (err, fields, files) =>
    createProductFormCallback(req, res, err, fields, files)
  );
};

/**
 * Update product
 *
 * @remarks
 *
 * Shape of req.body (all fields being optional)
 * - title
 * - description
 * - info
 * - price
 * - tags
 * - quantityLeft
 * - coverImgs - array of img files which displays product
 *
 * This current set of coverImgURLs which will be generated for this coverImgs
 * (if there) will replace the previous coverImgURLs
 *
 * User this in conjuntion with
 * - getProductById middleware which will set `rwq.product`
 *
 * @todo
 * - If coverImgs are updated then old imgs will be replace with these new imgs. So add
 * a feature when imgs can be added to existing imgs and individual img can be removed
 * - Add a check whether the user updating the product is the creator of the product
 */
export const updateProduct: Controller = async (req, res) => {
  let form = new IncomingForm({ keepExtensions: true, multiples: true });
  form.parse(req, (err, fields, files) =>
    updateProductFormCallback(req, res, err, fields, files)
  );
};

/**
 * Delete product
 *
 * @todos
 * - Add a check whether the user deleting the product is the creator of the product
 */
export const deleteProduct: Controller = async (req, res) => {
  const product = req.product;
  const user = req.profile;

  // Delete current coverImgs for the product
  const destination = `product-imgs/${user._id}/${product._id}`;
  const wasDeleted = await deleteFileInFirebaseStorage(destination);
  if (!wasDeleted) return responseMsg(res);

  // Delete product doc
  const [, err] = await runAsync(
    Product.deleteOne({ _id: product._id }).exec()
  );
  if (err) return responseMsg(res);
  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Successfully deleted the product",
  });
};

/**
 * Purchase products
 *
 * @remarks
 *
 * User product purchase flow
 * - User will add items to cart and then go checkout where the person will give
 * card detials and submit
 * - In the backend we'll first charge the user then once it is successful the n we'll
 * charge the user
 *
 * Shape of req.body will be
 * - products - ProductOrderDocument[]
 * - payment_method
 *
 * The req.params should have ueserId
 * - userId - user id, who is purchasing
 *
 * Here shape of each product in products will be
 * - sellerId - user id, who is selling
 * - productId
 * - price - price of individual product
 * - quantity
 *
 * @todo
 * - Handle the case where the user is charged and orders are not created
 * - Another way of first create orders and then charge the user and also setup
 * webhook for this payment. If the user payment fails then using the webhook the
 * make the payment status field in product order (this field is not there, we've to
 * create it) as default or pending. But for this we've to add a feature where user
 * can pay for the default amount for seleted (by the user) products
 */
export const purchaseProducts: Controller = async (req, res) => {
  const user = req.profile;

  // Getting total amount to charge user and orders for the products
  let orders = [];
  let totalAmount = 0;
  (req.body.products as any[]).forEach((p) => {
    orders.push({ userId: user._id, ...p });
    totalAmount = totalAmount + p.quantity * p.price;
  });

  // Charging the user
  const { payment_method } = req.body;
  const paymentIntent = await createPaymentIntentAndCharge(
    user._id,
    totalAmount,
    payment_method
  );
  if (!paymentIntent) return responseMsg(res);

  // Creating orders
  const [savedOrders, err1] = await runAsync(ProductOrder.insertMany(orders));
  if (err1 || !savedOrders) return responseMsg(res);

  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Payment made successfully",
  });
};

/**
 * Get all products
 */
export const getProducts: Controller = async (req, res) => {
  const next = req.query.next;
  const LIMIT = 4;
  const limit = req.query.limit ? parseInt(req.query.limit as string) : LIMIT;

  const [data, err1] = await runAsync(
    (Product as any).paginateProduct({
      limit: limit,
      paginatedField: "updatedAt",
      next,
    })
  );
  if (err1) return responseMsg(res);

  let products = [];
  for (let i = 0; i < data.results.length; i++) {
    const [p, err2] = await runAsync(
      Product.populate(data.results[i], "userId tags")
    );
    if (err2) return responseMsg(res);
    const product: ProductDocument = p;

    products.push({
      id: product._id,
      title: product.title,
      description: product.description,
      info: product.info,
      price: product.price,
      coverImgURLs: product.coverImgURLs,
      quantityLeft: product.quantityLeft,
      user: {
        id: product.userId._id,
        email: product.userId.email,
        username: product.userId.username,
        profilePicURL: product.userId.profilePicURL,
        dateOfBirth: product.userId.dateOfBirth,
        roles: product.userId.roles,
      },
      tags: product.tags.map((tag: any) => ({
        id: tag._id,
        emoji: tag.emoji,
        name: tag.name,
        description: tag.description,
      })),
    });
  }

  return responseMsg(res, {
    status: 200,
    error: false,
    msg: `Retrived ${products.length} products successfully`,
    data: {
      products,
      previous: data.previous,
      hasPrevious: data.hasPrevious,
      next: data.next,
      hasNext: data.hasNext,
    },
  });
};

/**
 * Get all products for a tag
 *
 * @remarks
 *
 * As of now this controller **returns the entire collection** (filtered) and there is
 * no pagaination
 *
 * The below code doesn't gives result because of `query`. In `MongoPaging.find`
 * only simple query work and not others
 *
 * ```ts
 * MongoPaging.find(Product.collection, {
 *    query: { tags: { $all: [req.params.tagId] } },
 *    paginatedField: "updatedAt",
 *    limit,
 *    next,
 *  })
 * ```
 *
 * Queries like below work but not above ones
 *
 * ```ts
 * MongoPaging.find(Product.collection, {
 *    query: { username: req.params.username },
 *    paginatedField: "updatedAt",
 *    limit,
 *    next,
 *  })
 * ```
 */
export const getProductsForTag: Controller = async (req, res) => {
  const limit = req.query.limit;

  const [data, err1] = await runAsync(
    limit
      ? Product.find({ tags: { $all: [req.params.tagId] } })
          .populate("userId tags")
          .limit(parseInt(limit as string))
          .exec()
      : Product.find({ tags: { $all: [req.params.tagId] } })
          .populate("userId tags")
          .exec()
  );
  if (err1) return responseMsg(res);

  let products = [];
  for (let i = 0; i < data.length; i++) {
    const product: ProductDocument = data[i];

    products.push({
      id: product._id,
      title: product.title,
      description: product.description,
      info: product.info,
      price: product.price,
      coverImgURLs: product.coverImgURLs,
      quantityLeft: product.quantityLeft,
      user: {
        id: product.userId._id,
        email: product.userId.email,
        username: product.userId.username,
        profilePicURL: product.userId.profilePicURL,
        dateOfBirth: product.userId.dateOfBirth,
        roles: product.userId.roles,
      },
      tags: product.tags.map((tag: any) => ({
        id: tag._id,
        emoji: tag.emoji,
        name: tag.name,
        description: tag.description,
      })),
    });
  }

  return responseMsg(res, {
    status: 200,
    error: false,
    msg: `Retrived ${products.length} products successfully`,
    data: { products },
  });
};

/**
 * Search products
 */
export const searchProducts: Controller = async (req, res) => {
  const searchQuery = req.body.searchQuery;
  const next = req.query.next;
  const LIMIT = 4;
  const limit = req.query.limit ? parseInt(req.query.limit as string) : LIMIT;

  const [data, err1] = await runAsync(
    MongoPaging.search(Product.collection, searchQuery, {
      limit: limit,
      fields: {
        title: 1,
        description: 1,
        info: 1,
        price: 1,
        coverImgURLs: 1,
        quantityLeft: 1,
        userId: 1,
        tags: 1,
      },
      next,
    })
  );

  if (err1) return responseMsg(res);
  if (!data)
    return responseMsg(res, {
      status: 200,
      error: false,
      msg: "No results found",
      data: { posts: [], next: null },
    });

  let products = [];
  for (let i = 0; i < data.results.length; i++) {
    const [p, err2] = await runAsync(
      Product.populate(data.results[i], "userId tags")
    );
    if (err2) return responseMsg(res);
    const product: ProductDocument = p;

    products.push({
      id: product._id,
      title: product.title,
      description: product.description,
      info: product.info,
      price: product.price,
      coverImgURLs: product.coverImgURLs,
      quantityLeft: product.quantityLeft,
      user: {
        id: product.userId._id,
        email: product.userId.email,
        username: product.userId.username,
        profilePicURL: product.userId.profilePicURL,
        dateOfBirth: product.userId.dateOfBirth,
        roles: product.userId.roles,
      },
      tags: product.tags.map((tag: any) => ({
        id: tag._id,
        emoji: tag.emoji,
        name: tag.name,
        description: tag.description,
      })),
    });
  }

  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Search results",
    data: { products, next: data.next },
  });
};
