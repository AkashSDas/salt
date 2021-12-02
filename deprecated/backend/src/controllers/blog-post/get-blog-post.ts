import { Request, Response } from "express";
import { responseMsg } from "../json-response";

function getBlogPost(req: Request, res: Response) {
  return responseMsg(res, {
    status: 200,
    error: false,
    message: "Successfully retrived post",
    data: { post: req.blogPost },
  });
}

export default getBlogPost;
