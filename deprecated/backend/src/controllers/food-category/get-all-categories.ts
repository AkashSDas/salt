import { Request, Response } from "express";
import FoodCategory from "../../models/food-category";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

async function getAllCategories(req: Request, res: Response) {
  const [categories, err] = await runAsync(FoodCategory.find().exec());

  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Failed to retrive categories",
    });

  return responseMsg(res, {
    status: 200,
    error: false,
    message: `Retrived categories successfully`,
    data: { categories },
  });
}

export default getAllCategories;
