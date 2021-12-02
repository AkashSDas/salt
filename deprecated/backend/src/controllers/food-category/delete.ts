import { Request, Response } from "express";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

async function deleteCategory(req: Request, res: Response) {
  const category = req.foodCategory;
  const [data, err] = await runAsync(category.deleteOne({ _id: category._id }));
  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Failed to delete category",
    });

  if (!data)
    return responseMsg(res, {
      status: 400,
      message: "Category does not exists",
    });

  return responseMsg(res, {
    status: 200,
    error: false,
    message: "Successfully deleted category",
    data: { deletedCategory: data },
  });
}

export default deleteCategory;
