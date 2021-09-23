import { Request, Response } from "express";
import { Order, OrderDocument } from "../../models/order";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

async function getAllOrders(req: Request, res: Response) {
  /// if their is next id then use it to get data from that document
  /// if it is undefined then paginateUser will give documents from start
  const next = req.query.next;

  const LIMIT = 1;
  const limit = req.query.limit ? parseInt(req.query.limit as string) : LIMIT;

  const [data, err] = await runAsync(
    await (Order as any).paginateOrder({
      limit,
      paginatedField: "updatedAt",
      next,
    })
  );

  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Failed to retrive orders",
    });

  /// since traditional for loop is more performant then forEach and
  /// here we can have lots of data to loop, so tranditional for loop
  /// is used
  const orders = [];
  for (let i = 0; i < data.results.length; i++) {
    const [o, err] = await runAsync(Order.populate(data.results[i], "user"));

    if (err)
      return responseMsg(res, {
        status: 400,
        message: "Failed to retrive orders",
      });

    const order: OrderDocument = o;

    orders.push({
      id: order._id,
      products: order.products,
      transactionId: order.transactionId,
      amount: order.amount,
      address: order.address,
      status: order.status,
      user: {
        id: order.user._id,
        username: order.user.username,
        email: order.user.email,
        role: order.user.role,
      },
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
    });
  }

  return responseMsg(res, {
    status: 200,
    error: false,
    message: `Retrived ${orders.length} orders successfully`,
    data: {
      orders,
      previous: data.previous,
      hasPrevious: data.hasPrevious,
      next: data.next,
      hasNext: data.hasNext,
    },
  });
}

export default getAllOrders;
