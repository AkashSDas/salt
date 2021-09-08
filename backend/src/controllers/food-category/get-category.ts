import { Request, Response } from "express";
import { responseMsg } from "../json-response";

function getCategory(req: Request, res: Response) {
  return responseMsg(res, {
    status: 200,
    error: false,
    message: "Category retrived successfully",
    data: { category: req.foodCategory },
  });
}

export default getCategory;
