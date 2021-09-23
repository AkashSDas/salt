import { NextFunction, Request, Response } from "express";
import Product, { ProductDocument } from "../../models/product";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

export async function getProductById(
  req: Request,
  res: Response,
  next: NextFunction,
  id: string
) {
  const [data, err] = await runAsync(Product.findById(id).exec());

  if (err || !data)
    return responseMsg(res, {
      status: 400,
      message: "Product not found",
    });

  const product: ProductDocument = data;
  req.product = product;
  next();
}
