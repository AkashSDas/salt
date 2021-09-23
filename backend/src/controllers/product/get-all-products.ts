import { Request, Response } from "express";
import Product from "../../models/product";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

async function getAllProducts(req: Request, res: Response) {
  /// if their is next id then use it to get data from that document
  /// if it is undefined then paginateUser will give documents from start
  const next = req.query.next;

  const LIMIT = 1;
  const limit = req.query.limit ? parseInt(req.query.limit as string) : LIMIT;

  const [data, err] = await runAsync(
    await (Product as any).paginateProduct({
      limit,
      paginatedField: "updatedAt",
      next,
    })
  );

  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Failed to retrive products",
    });

  return responseMsg(res, {
    status: 200,
    error: false,
    message: `Retrived ${data.results.length} posts successfully`,
    data: {
      products: data.results,
      previous: data.previous,
      hasPrevious: data.hasPrevious,
      next: data.next,
      hasNext: data.hasNext,
    },
  });
}

export default getAllProducts;
