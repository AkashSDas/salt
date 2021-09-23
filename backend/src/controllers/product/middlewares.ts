import { NextFunction, Request, Response } from "express";
import MainUser from "../../models/main-user";
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
export async function updateProductStock(
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
        filter: { _id: product.id },

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

/// TODO: Refactor the items in purcahses list here
export function pushOrderInPurchaseList(
  req: Request,
  res: Response,
  next: NextFunction
) {
  let purchases = [];
  req.body.order.products.forEach((product) => {
    purchases.push({
      _id: product.id,
      title: product.title,
      description: product.description,
      quantity: product.quantity,
      price: product.price,
      transactionId: req.body.order.transactionId,
    });
  });

  // store this in database
  MainUser.findOneAndUpdate(
    { _id: req.profile._id },
    { $push: { purchases: purchases } },
    { new: true },
    (err, _purchases) => {
      if (err) {
        res.status(400).json({
          error: "Unable to save purchase list",
        });
      } else {
        next();
      }
    }
  );
}
