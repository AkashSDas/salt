import Product, { ProductDocument } from "../models/product";
import { IdMiddleware, responseMsg, runAsync } from "../utils";

/**
 * Get product (if exists) and set it to req.product
 *
 * @params
 * id: product mongodb id
 */
export const getProductById: IdMiddleware = async (req, res, next, id) => {
  const [data, err] = await runAsync(Product.findOne({ _id: id }).exec());
  if (err) return responseMsg(res);
  else if (!data) return responseMsg(res, { msg: "Product doesn't exists" });
  const p: ProductDocument = data;
  req.product = p;
  next();
};
