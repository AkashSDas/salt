import { IdMiddleware, responseMsg, runAsync } from "../utils";
import ProductOrder, { ProductOrderDocument } from "../models/product_order";

/**
 * Get product order (if exists) and set it to req.productOrder
 *
 * @params
 * id: product order mongodb id
 */
export const getProductOrderById: IdMiddleware = async (req, res, next, id) => {
  const [data, err] = await runAsync(ProductOrder.findOne({ _id: id }).exec());
  if (err) return responseMsg(res);
  else if (!data)
    return responseMsg(res, { msg: "Product order doesn't exists" });

  const p: ProductOrderDocument = data;
  req.productOrder = p;
  next();
};
