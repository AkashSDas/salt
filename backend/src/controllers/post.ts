import { Controller, responseMsg, runAsync } from "../utils";
import { IncomingForm } from "formidable";
import Post from "../models/post";
import {
  postCreateFormCallback,
  postUpdateFormCallback,
} from "../helpers/post";
import { deleteFileInFirebaseStorage } from "../firebase";

/**
 * Create post
 *
 * @remarks
 *
 * Shape of formdata will be
 * - title
 * - description
 * - content
 * - tags
 * - published
 * - coverImg (this will have the cover img)
 *
 * wordCount and readTime are computed in the backend and should be set by frontend
 *
 * This controller should be used in conjunction with
 * - auth middlewares
 * - getUserById middleware which will set req.profile which will used for userId
 */
export const createPost: Controller = async (req, res) => {
  let form = new IncomingForm({ keepExtensions: true });
  form.parse(req, (err, fields, files) =>
    postCreateFormCallback(req, res, err, fields, files)
  );
};

/**
 * Update post
 *
 * @remarks
 *
 * This controller should be used in conjunction with
 * - getPostById middleware which will set the `req.post`
 *
 * Shape of req.body (with all fields being optional)
 * - title
 * - description
 * - content
 * - published
 * - coverImg (this is a img file, this will be updated with course
 * cover img and then coverImgURL will be updated)
 * - tags
 *
 * wordCount and readTime are computed in the backend and should be set by frontend
 *
 * @todo
 * - Create separate route for publishing a post rather that publishing directly and there
 * add checks whether the post should be published or not
 * - Add check whether user updating the post is the author of the post or not
 */
export const updatePost: Controller = async (req, res) => {
  let form = new IncomingForm({ keepExtensions: true });
  form.parse(req, (err, fields, files) =>
    postUpdateFormCallback(req, res, err, fields, files)
  );
};

/**
 * Delete post
 *
 * @remarks
 * Use this controller in conjunction with getPostById which will set `req.post`
 *
 * @todo
 * - Instead of getting entire post just get the post id with validation check if
 * its there or not
 * - Add check whether user deleting the post is the author of the post or not
 */
export const deletePost: Controller = async (req, res) => {
  const post = req.post;
  const user = req.profile;

  // Delete post cover img
  const path = `post-cover-imgs/${user._id}/${post._id}`;
  const isDeleted = await deleteFileInFirebaseStorage(path);
  if (!isDeleted) return responseMsg(res);

  // Delete post doc
  const [, err] = await runAsync(Post.deleteOne({ _id: post._id }).exec());
  if (err) return responseMsg(res);

  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Successfully deleted the post",
  });
};
