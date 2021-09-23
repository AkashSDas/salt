import { Request, Response } from "express";
import { Order } from "../../models/order";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

async function createOrder(req: Request, res: Response) {
  /// Get the user making order
  req.body.order.user = req.profile;

  const order = new Order(req.body.order);
  const [savedOrder, err] = await runAsync(order.save());
  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Failed to save order in database",
    });

  return responseMsg(res, {
    status: 200,
    error: false,
    message: "Successfully saved order",
    data: { order: savedOrder },
  });
}

export default createOrder;
