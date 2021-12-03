import { Fields, File, Files } from "formidable";
import { Request, Response } from "express";
import { responseMsg, runAsync } from "../utils";
import { uploadToFirebaseStorage } from "../firebase";
import Product from "../models/product";

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

  let product = new Product({ userId: user._id, ...req.body });

  let coverImgURLs = [];
  for await (const img of coverImgs as File[]) {
    const url = await uploadToFirebaseStorage(
      `product-imgs/${user._id}/${product._id}`,
      img as File,
      { contentType: "image/png" }
    );
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
