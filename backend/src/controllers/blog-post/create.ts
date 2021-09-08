import { Request, Response } from "express";
import BlogPost, { BlogPostDocument } from "../../models/blog-post";
import { runAsync } from "../../utils";
import { expressValidatorErrorResponse, responseMsg } from "../json-response";

/// TODO: add formdata parser and upload image to firebase
async function createBlogPost(req: Request, res: Response) {
  const [errors, jsonRes] = expressValidatorErrorResponse(req, res);
  if (errors) return jsonRes;

  const category = new BlogPost(req.body);
  const [data, err] = await runAsync(category.save());
  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Not able to create post",
    });

  const savedPost: BlogPostDocument = data;
  return responseMsg(res, {
    status: 200,
    error: false,
    message: "Post created successfully",
    data: { post: savedPost },
  });
}

export default createBlogPost;
