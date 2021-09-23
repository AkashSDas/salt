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

/// Update product stock whenever someone successfully pays for it
async function updateProductStock(
  req: Request,
  res: Response,
  next: NextFunction
) {
  /// Going through each product that user has successfully payed for
  /// in the order and creating updateOne operation for each where stock
  /// is descreased and sold is increased
  let operations = req.body.order.products.map((product) => {
    return {
      updateOne: {
        filter: { _id: product._id },

        /// increasing sold and decreasing stock
        update: {
          $inc: {
            quantity_left: -product.quantity,
            quantity_sold: +product.quantity,
          },
        },
      },
    };
  });

  /// Performing bulk write
  const options = {};
  const [_, err] = await runAsync(Product.bulkWrite(operations, options));
  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Failed to update product stock",
    });

  next();
}

export default updateProductStock;
