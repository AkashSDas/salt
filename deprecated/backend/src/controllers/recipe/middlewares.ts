import { NextFunction, Request, Response } from "express";
import Recipe, { RecipeDocument } from "../../models/recipe";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

export async function getRecipeById(
  req: Request,
  res: Response,
  next: NextFunction,
  id: string
) {
  const [data, err] = await runAsync(
    Recipe.findById(id).populate("author").populate("categories").exec()
  );

  if (err || !data)
    return responseMsg(res, {
      status: 400,
      message: "Recipe not found",
    });

  const recipe: RecipeDocument = data;
  req.recipe = recipe;
  next();
}
