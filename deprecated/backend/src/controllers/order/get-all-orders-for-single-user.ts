import { Request, Response } from "express";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";
import MongoPaging from "mongo-cursor-pagination";
import { Order, OrderDocument } from "../../models/order";

async function getAllOrdersForSingleUser(req: Request, res: Response) {
  const next = req.query.next;

  const LIMIT = 1;
  const limit = req.query.limit ? parseInt(req.query.limit as string) : LIMIT;

  const profile = req.profile;

  const [data, err] = await runAsync(
    MongoPaging.find(Order.collection, {
      query: { user: profile._id },
      paginatedField: "updatedAt",
      limit,
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
    const order: OrderDocument = data.results[i];

    orders.push({
      id: order._id,
      products: order.products,
      transactionId: order.transactionId,
      amount: order.amount,
      address: order.address,
      status: order.status,
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

export default getAllOrdersForSingleUser;
