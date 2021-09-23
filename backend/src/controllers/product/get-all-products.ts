import { Request, Response } from "express";
import Product, { ProductDocument } from "../../models/product";
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

  let products = [];
  data.results.forEach((p: ProductDocument) => {
    products.push({
      id: p._id,
      title: p.title,
      description: p.description,
      coverImgURLs: p.coverImgURLs,
      quantity_left: p.quantity_left,
      quantity_sold: p.quantity_sold,
      price: p.price,
      createdAt: p.createdAt,
      updatedAt: p.updatedAt,
    });
  });

  return responseMsg(res, {
    status: 200,
    error: false,
    message: `Retrived ${data.results.length} posts successfully`,
    data: {
      products,
      previous: data.previous,
      hasPrevious: data.hasPrevious,
      next: data.next,
      hasNext: data.hasNext,
    },
  });
}

export default getAllProducts;
