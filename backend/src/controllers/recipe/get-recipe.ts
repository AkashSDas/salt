import { Request, Response } from "express";
import { responseMsg } from "../json-response";

function getRecipe(req: Request, res: Response) {
  return responseMsg(res, {
    status: 200,
    error: false,
    message: "Successfully retrived recipe",
    data: { post: req.recipe },
  });
}

export default getRecipe;
