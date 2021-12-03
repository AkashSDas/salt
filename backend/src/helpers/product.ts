import { Fields, File, Files } from "formidable";
import { Request, Response } from "express";
import { responseMsg, runAsync } from "../utils";
import {
  deleteFileInFirebaseStorage,
  uploadToFirebaseStorage,
} from "../firebase";
import Product from "../models/product";
import { extend } from "lodash";

/**
 * This function is a callback for formidable IncomingForm.parse callback in
 * **createProduct** controller
 *
 * @remarks
 * This callback is used to create a product
 */
export const createProductFormCallback = async (
  req: Request,
  res: Response,
  err: any,
  fields: Fields,
  files: Files
): Promise<void> => {
  // If user is coming till here after passing all vaidators then chances are
  // high that the problem is in the file itself
  if (err) responseMsg(res, { msg: "There is some issue with the file" });

  const user = req.profile;

  const { coverImgs } = files;
  if (!coverImgs)
    return responseMsg(res, { msg: "Images of product are missing" });

  let product = new Product({ userId: user._id, ...fields });

  let coverImgURLs = [];
  const destination = `product-imgs/${user._id}/${product._id}`;
  for await (const img of coverImgs as File[]) {
    const url = await uploadToFirebaseStorage(destination, img as File, {
      contentType: "image/png",
    });
    if (url.length === 0) return responseMsg(res);
    coverImgURLs.push(url);
  }
  product.coverImgURLs = coverImgURLs;
  const [savedProduct, err2] = await runAsync(product.save());
  if (err2 || !savedProduct) return responseMsg(res);
  const [fullProduct, err3] = await runAsync(
    savedProduct.populate("userId tags")
  );
  if (err3 || !fullProduct) return responseMsg(res);
  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Successfully create a product",
    data: { product: fullProduct },
  });
};

/**
 * Update product
 */
export const updateProductFormCallback = async (
  req: Request,
  res: Response,
  err: any,
  fields: Fields,
  files: Files
): Promise<void> => {
  // If user is coming till here after passing all vaidators then chances are
  // high that the problem is in the file itself
  if (err) responseMsg(res, { msg: "There is some issue with the file" });

  const user = req.profile;

  let product = req.product;
  // updating product object with new updated data sent by user
  product = extend(product, fields);

  if (files.coverImgs) {
    // Delete current coverImgs for the product
    const destination = `product-imgs/${user._id}/${product._id}`;
    const wasDeleted = await deleteFileInFirebaseStorage(destination);
    if (!wasDeleted) return responseMsg(res);

    // Save new coverImgs
    let coverImgURLs = [];
    for await (const img of files.coverImgs as File[]) {
      const url = await uploadToFirebaseStorage(destination, img as File, {
        contentType: "image/png",
      });
      if (url.length === 0) return responseMsg(res);
      coverImgURLs.push(url);
    }
    product.coverImgURLs = coverImgURLs;
  }

  const [updatedProduct, err2] = await runAsync(product.save());
  if (err2 || !updatedProduct) return responseMsg(res);
  const [fullProduct, err3] = await runAsync(
    updatedProduct.populate("userId tags")
  );
  if (err3 || !fullProduct) return responseMsg(res);
  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Successfully updated the product",
    data: { product: fullProduct },
  });
};