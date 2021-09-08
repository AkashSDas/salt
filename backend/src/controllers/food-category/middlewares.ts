import { NextFunction, Request, Response } from "express";
import FoodCategory, { FoodCategoryDocument } from "../../models/food-category";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

/**
 *
 * @param req Request
 * @param res Response
 * @param next NextFunction
 * @param id string - category id
 */
export async function getCategoryById(
  req: Request,
  res: Response,
  next: NextFunction,
  id: string
) {
  const [data, err] = await runAsync(FoodCategory.findById(id).exec());
  if (err || !data)
    return responseMsg(res, {
      status: 400,
      message: "Category not found",
    });

  const category: FoodCategoryDocument = data;
  req.foodCategory = category;
  next();
}
