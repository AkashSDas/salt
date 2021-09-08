import { Request, Response } from "express";
import { FoodCategoryDocument } from "../../models/food-category";
import { runAsync } from "../../utils";
import { expressValidatorErrorResponse, responseMsg } from "../json-response";

async function updateCategory(req: Request, res: Response) {
  const [errors, jsonRes] = expressValidatorErrorResponse(req, res);
  if (errors) return jsonRes;

  const category = req.foodCategory;
  category.name = req.body.name;
  category.emoji = req.body.emoji;
  category.description = req.body.description;

  const [data, err] = await runAsync(category.save());

  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Failed to update the category",
    });

  if (!data)
    return responseMsg(res, {
      status: 400,
      message: "Category does not exists",
    });

  const updatedCategory: FoodCategoryDocument = data;
  return responseMsg(res, {
    status: 200,
    error: false,
    message: "Category has been successfully updated",
    data: { updatedCategory },
  });
}

export default updateCategory;
