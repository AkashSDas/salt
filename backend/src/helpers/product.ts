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

  // Parse tags
  try {
    fields.tags = JSON.parse(fields.tags as string);
  } catch (er) {
    return responseMsg(res, { status: 400, msg: "Tags have wrong format" });
  }

  let product = new Product({ userId: user._id, ...fields });

  let coverImgURLs = [];
  const destination = `product-imgs/${user._id}/${product._id}`;

  try {
    // If this fails for `TypeError` it might be because coverImgs have
    // only one file in which case coverImgs is not an array and we'll
    // get the below error
    // TypeError: o[Symbol.iterator] is not a function
    //
    // But this might be one of the reasons of this block's failure

    for await (const img of coverImgs as File[]) {
      const url = await uploadToFirebaseStorage(destination, img as File, {
        contentType: "image/png",
      });
      if (url.length === 0) return responseMsg(res);
      coverImgURLs.push(url);
    }
  } catch (e) {
    try {
      // If coverImgs is not a single file and the error above caused because
      // of some other reasons, therefore having this try/catch block
      const url = await uploadToFirebaseStorage(
        destination,
        coverImgs as File,
        {
          contentType: "image/png",
        }
      );
      if (url.length === 0) return responseMsg(res);
      coverImgURLs.push(url);
    } catch (e) {}
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
    data: {
      product: {
        id: fullProduct._id,
        title: fullProduct.title,
        description: fullProduct.description,
        info: fullProduct.info,
        price: fullProduct.price,
        coverImgURLs: fullProduct.coverImgURLs,
        user: {
          id: fullProduct.userId._id,
          email: fullProduct.userId.email,
          username: fullProduct.userId.username,
          profilePicURL: fullProduct.userId.profilePicURL,
          dateOfBirth: fullProduct.userId.dateOfBirth,
          roles: fullProduct.userId.roles,
        },
        tags: fullProduct.tags.map((tag: any) => ({
          id: tag._id,
          emoji: tag.emoji,
          name: tag.name,
        })),
      },
    },
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

  // Parse tags
  try {
    fields.tags = JSON.parse(fields.tags as string);
  } catch (er) {
    return responseMsg(res, { status: 400, msg: "Tags have wrong format" });
  }

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

    try {
      // If this fails for `TypeError` it might be because coverImgs have
      // only one file in which case coverImgs is not an array and we'll
      // get the below error
      // TypeError: o[Symbol.iterator] is not a function
      //
      // But this might be one of the reasons of this block's failure

      for await (const img of files.coverImgs as File[]) {
        const url = await uploadToFirebaseStorage(destination, img as File, {
          contentType: "image/png",
        });
        if (url.length === 0) return responseMsg(res);
        coverImgURLs.push(url);
      }
    } catch (e) {
      try {
        // If coverImgs is not a single file and the error above caused because
        // of some other reasons, therefore having this try/catch block
        const url = await uploadToFirebaseStorage(
          destination,
          files.coverImgs as File,
          {
            contentType: "image/png",
          }
        );
        if (url.length === 0) return responseMsg(res);
        coverImgURLs.push(url);
      } catch (e) {}
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
    data: {
      product: {
        id: fullProduct._id,
        title: fullProduct.title,
        description: fullProduct.description,
        info: fullProduct.info,
        price: fullProduct.price,
        coverImgURLs: fullProduct.coverImgURLs,
        user: {
          id: fullProduct.userId._id,
          email: fullProduct.userId.email,
          username: fullProduct.userId.username,
          profilePicURL: fullProduct.userId.profilePicURL,
          dateOfBirth: fullProduct.userId.dateOfBirth,
          roles: fullProduct.userId.roles,
        },
        tags: fullProduct.tags.map((tag: any) => ({
          id: tag._id,
          emoji: tag.emoji,
          name: tag.name,
        })),
      },
    },
  });
};
