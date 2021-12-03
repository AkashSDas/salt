import ProductOrder from "../models/product_order";
import { Controller, responseMsg, runAsync } from "../utils";

/**
 * Create product order
 *
 * @remarks
 *
 * Shape of req.body will be
 * - products - ProductOrderDocument[]
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
 * The flow of user purchasing product(s) is
 * - user puts things to cart
 * - user enters card detail to make payment
 * - backend first creates all the orders for individual product in the cart
 * - when the above step is successful then user is charged the full amount of purchase
 */
export const createProductOrder: Controller = async (req, res) => {
  const user = req.profile;

  let orders = [];
  (req.body.products as any[]).forEach((p) => {
    orders.push({ userId: user._id, ...p });
  });

  const [savedOrders, err] = await runAsync(ProductOrder.insertMany(orders));
  if (err || !savedOrders) return responseMsg(res);
  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Successfully created orders",
    data: { orders: savedOrders },
  });
};
