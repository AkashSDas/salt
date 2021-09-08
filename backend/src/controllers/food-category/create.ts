import { Request, Response } from "express";
import FoodCategory, { FoodCategoryDocument } from "../../models/food-category";
import { runAsync } from "../../utils";
import { expressValidatorErrorResponse, responseMsg } from "../json-response";

async function createCategory(req: Request, res: Response) {
  const [errors, jsonRes] = expressValidatorErrorResponse(req, res);
  if (errors) return jsonRes;

  const category = new FoodCategory(req.body);
  const [data, err] = await runAsync(category.save());
  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Not able to create category",
    });

  const savedCategory: FoodCategoryDocument = data;
  return responseMsg(res, {
    status: 200,
    error: false,
    message: "Category created successfully",
    data: { category: savedCategory },
  });
}

export default createCategory;
