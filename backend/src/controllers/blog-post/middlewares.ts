import { NextFunction, Request, Response } from "express";
import BlogPost, { BlogPostDocument } from "../../models/blog-post";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

export async function getBlogPostById(
  req: Request,
  res: Response,
  next: NextFunction,
  id: string
) {
  const [data, err] = await runAsync(
    BlogPost.findById(id).populate("author").populate("categories").exec()
  );

  if (err || !data)
    return responseMsg(res, {
      status: 400,
      message: "Post not found",
    });

  const blogPost: BlogPostDocument = data;
  req.blogPost = blogPost;
  next();
}
