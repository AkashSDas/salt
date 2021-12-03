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
import { Controller, responseMsg, runAsync } from "../utils";

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
