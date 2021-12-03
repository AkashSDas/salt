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
import Product from "../models/product";
import ProductOrder from "../models/product_order";
import { Controller, responseMsg, runAsync } from "../utils";
import { createPaymentIntentAndCharge } from "../payments/payment";

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
  if (!err) return responseMsg(res);
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
