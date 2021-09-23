import { Request, Response } from "express";
import { bucket } from "../../firebase";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

async function deleteProduct(req: Request, res: Response) {
  const product = req.product;
  const userId = req.product._id;

  /// Delete all cover imgs
  /// Note: Be careful with deleteFiles, if empty string
  /// is passed to prefix then it will delete everything
  /// in the bucket
  const [_deleteResult, _deleteError] = await runAsync(
    bucket.deleteFiles({
      prefix: `products/${userId}/${product._id}`,
    })
  );

  if (_deleteError)
    return responseMsg(res, {
      status: 400,
      message: "Failed to delete product cover images",
    });

  /// Delete mongodb document
  const [data, err] = await runAsync(product.deleteOne({ _id: product._id }));
  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Failed to delete product",
    });

  if (!data)
    return responseMsg(res, {
      status: 400,
      message: "Product does not exists",
    });

  return responseMsg(res, {
    status: 200,
    error: false,
    message: "Successfully deleted product",
    data: { deletedProduct: data },
  });
}

export default deleteProduct;
