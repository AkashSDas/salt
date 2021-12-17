import { Request, Response } from "express";
import { Fields, File, Files } from "formidable";
import { responseMsg, runAsync } from "../utils";
import { extend } from "lodash";
import {
  deleteFileInFirebaseStorage,
  uploadToFirebaseStorage,
} from "../firebase";
import Post from "../models/post";

/**
 * This funciton is a callback for formidable IncomingForm.parse callback in
 * **createPost** controller
 *
 * @remarks
 * This callback does the creating work of post data.
 */
export const postCreateFormCallback = async (
  req: Request,
  res: Response,
  err: any,
  fields: Fields,
  files: Files
): Promise<void> => {
  // If user is coming till here after passing all vaidators then chances are
  // high that the problem is in the file itself
  if (err) responseMsg(res, { msg: "There is some issue with the file" });

  const user = req.profile;

  // Parse tags
  try {
    fields.tags = JSON.parse(fields.tags as string);
  } catch (er) {
    return responseMsg(res, { status: 400, msg: "Tags have wrong format" });
  }

  // Parse published
  try {
    fields.published = JSON.parse(fields.published as string);
  } catch (er) {
    return responseMsg(res, {
      status: 400,
      msg: "Published status have wrong format",
    });
  }

  // Naive method to calc word count and read time
  const wordCount = (fields.content as string).trim().split(/\s+/g).length;
  const readTime = parseFloat((wordCount / 100 + 1).toFixed(0));

  let post = new Post({ userId: user._id, ...fields, wordCount, readTime });

  if (!files.coverImg) {
    return responseMsg(res, {
      error: true,
      status: 400,
      msg: "Cover image is required",
    });
  } else {
    const destination = `post-cover-imgs/${user._id}/${post._id}`;

    // Upload img
    const url = await uploadToFirebaseStorage(
      destination,
      files.coverImg as File,
      { contentType: "image/png" }
    );
    if (url.length === 0) return responseMsg(res);
    post.coverImgURL = url;
  }

  const [data, err2] = await runAsync(post.save());
  if (err2 || !data) return responseMsg(res);
  const [fullPost, err3] = await runAsync(data.populate("userId tags"));
  if (err3 || !fullPost) return responseMsg(res);
  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Successfully created a post",
    data: {
      post: {
        id: fullPost._id,
        title: fullPost.title,
        description: fullPost.description,
        content: fullPost.content,
        readTime: fullPost.readTime,
        wordCount: fullPost.wordCount,
        published: fullPost.published,
        coverImgURL: fullPost.coverImgURL,
        user: {
          id: fullPost.userId._id,
          email: fullPost.userId.email,
          username: fullPost.userId.username,
          profilePicURL: fullPost.userId.profilePicURL,
          dateOfBirth: fullPost.userId.dateOfBirth,
          roles: fullPost.userId.roles,
        },
        tags: fullPost.tags.map((tag: any) => ({
          id: tag._id,
          emoji: tag.emoji,
          name: tag.name,
        })),
      },
    },
  });
};

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

  const user = req.profile;

  // Parse tags
  try {
    fields.tags = JSON.parse(fields.tags as string);
  } catch (er) {
    return responseMsg(res, { status: 400, msg: "Tags have wrong format" });
  }

  let post = req.post;
  // updating post object with new updated data sent by user
  post = extend(post, fields);

  if (files.coverImg) {
    // Delete img
    const destination = `post-cover-imgs/${user._id}/${post._id}`;
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
    data: {
      post: {
        id: fullPost._id,
        title: fullPost.title,
        description: fullPost.description,
        content: fullPost.content,
        readTime: fullPost.readTime,
        wordCount: fullPost.wordCount,
        published: fullPost.published,
        coverImgURL: fullPost.coverImgURL,
        user: {
          id: fullPost.userId._id,
          email: fullPost.userId.email,
          username: fullPost.userId.username,
          profilePicURL: fullPost.userId.profilePicURL,
          dateOfBirth: fullPost.userId.dateOfBirth,
          roles: fullPost.userId.roles,
        },
        tags: fullPost.tags.map((tag: any) => ({
          id: tag._id,
          emoji: tag.emoji,
          name: tag.name,
        })),
      },
    },
  });
};
