import ProductOrder from "../models/product_order";
import { Controller, responseMsg, runAsync } from "../utils";

export const getProductOrders: Controller = async (req, res) => {
  const [orders, err] = await runAsync(ProductOrder.find().exec());
  if (err) return responseMsg(res);
  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Orders retrieved",
    data: { orders },
  });
};
