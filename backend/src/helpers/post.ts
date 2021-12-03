import { Request, Response } from "express";
import { Fields, File, Files } from "formidable";
import { responseMsg, runAsync } from "../utils";
import { extend } from "lodash";
import {
  deleteFileInFirebaseStorage,
  uploadToFirebaseStorage,
} from "../firebase";

/**
 * This function is a callback for formidable IncomingForm.parse callback in
 * **updatePost** controller
 *
 * @remarks
 * This callback does the updating work of post data.
 */
export const postUpdateFormCallback = async (
  req: Request,
  res: Response,
  err: any,
  fields: Fields,
  files: Files
): Promise<void> => {
  // If user is coming till here after passing all vaidators then chances are
  // high that the problem is in the file itself
  if (err) responseMsg(res, { msg: "There is some issue with the file" });

  let post = req.post;
  // updating post object with new updated data sent by user
  post = extend(post, fields);

  if (files.coverImg) {
    // Delete img
    const destination = `post-cover-imgs/${post._id}`;
    const wasDeleted = await deleteFileInFirebaseStorage(destination);
    if (!wasDeleted) return responseMsg(res);

    // Upload img
    const url = await uploadToFirebaseStorage(
      destination,
      files.coverImg as File,
      { contentType: "image/png" }
    );
    if (url.length === 0) return responseMsg(res);
    post.coverImgURL = url;
  }

  // Naive method to calc word count and read time
  const wordCount = post.content.trim().split(/\s+/g).length;
  const readTime = parseFloat((wordCount / 100 + 1).toFixed(0));
  post.wordCount = wordCount;
  post.readTime = readTime;

  const [updatedPost, error] = await runAsync(post.save());
  if (error) return responseMsg(res);
  const [fullPost, error2] = await runAsync(
    updatedPost.populate("userId tags")
  );
  if (error2) return responseMsg(res);
  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Successfully updated the post",
    data: { post: fullPost },
  });
};
