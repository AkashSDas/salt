import Post, { PostDocument } from "../models/post";
import { IdMiddleware, responseMsg, runAsync } from "../utils";

/**
 * Get post (if exists) and set it to req.post
 *
 * @params
 * id: post mongodb id
 */
export const getPostById: IdMiddleware = async (req, res, next, id) => {
  const [data, err] = await runAsync(Post.findOne({ _id: id }).exec());
  if (err) return responseMsg(res);
  else if (!data) return responseMsg(res, { msg: "Post doesn't exists" });
  const p: PostDocument = data;
  req.post = p;
  next();
};
