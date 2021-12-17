import { Controller, responseMsg, runAsync } from "../utils";
import { IncomingForm } from "formidable";
import Post, { PostDocument } from "../models/post";
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

/**
 * Get all posts paginated
 */
export const getPosts: Controller = async (req, res) => {
  const next = req.query.next;
  const LIMIT = 4;
  const limit = req.query.limit ? parseInt(req.query.limit as string) : LIMIT;

  const [data, err1] = await runAsync(
    (Post as any).paginatePost({
      limit: limit,
      paginatedField: "updatedAt",
      next,
    })
  );
  if (err1) return responseMsg(res);

  let posts = [];
  for (let i = 0; i < data.results.length; i++) {
    const [p, err2] = await runAsync(
      Post.populate(data.results[i], "userId tags")
    );
    if (err2) return responseMsg(res);
    const post: PostDocument = p;

    posts.push({
      id: post._id,
      title: post.title,
      description: post.description,
      content: post.content,
      readTime: post.readTime,
      wordCount: post.wordCount,
      published: post.published,
      coverImgURL: post.coverImgURL,
      updatedAt: (post as any).updatedAt,
      createdAt: (post as any).createdAt,
      user: {
        id: post.userId._id,
        email: post.userId.email,
        username: post.userId.username,
        profilePicURL: post.userId.profilePicURL,
        dateOfBirth: post.userId.dateOfBirth,
        roles: post.userId.roles,
      },
      tags: post.tags.map((tag: any) => ({
        id: tag._id,
        name: tag.name,
        emoji: tag.emoji,
      })),
    });
  }

  return responseMsg(res, {
    status: 200,
    error: false,
    msg: `Retrived ${posts.length} posts successfully`,
    data: {
      posts,
      previous: data.previous,
      hasPrevious: data.hasPrevious,
      next: data.next,
      hasNext: data.hasNext,
    },
  });
};

/**
 * Get all posts for a tag
 *
 * @remarks
 *
 * As of now this controller **returns the entire collection** (filtered) and there is
 * no pagaination
 *
 * The below code doesn't gives result because of `query`. In `MongoPaging.find`
 * only simple query work and not others
 *
 * ```ts
 * MongoPaging.find(Product.collection, {
 *    query: { tags: { $all: [req.params.tagId] } },
 *    paginatedField: "updatedAt",
 *    limit,
 *    next,
 *  })
 * ```
 *
 * Queries like below work but not above ones
 *
 * ```ts
 * MongoPaging.find(Product.collection, {
 *    query: { username: req.params.username },
 *    paginatedField: "updatedAt",
 *    limit,
 *    next,
 *  })
 * ```
 */
export const getPostsForTag: Controller = async (req, res) => {
  const limit = req.query.limit;

  const [data, err1] = await runAsync(
    limit
      ? Post.find({ tags: { $all: [req.params.tagId] } })
          .populate("userId tags")
          .limit(parseInt(limit as string))
          .exec()
      : Post.find({ tags: { $all: [req.params.tagId] } })
          .populate("userId tags")
          .exec()
  );
  if (err1) return responseMsg(res);

  let posts = [];
  for (let i = 0; i < data.length; i++) {
    const post: PostDocument = data[i];

    posts.push({
      id: post._id,
      title: post.title,
      description: post.description,
      content: post.content,
      readTime: post.readTime,
      wordCount: post.wordCount,
      published: post.published,
      coverImgURL: post.coverImgURL,
            updatedAt: (post as any).updatedAt,
      createdAt: (post as any).createdAt,
      user: {
        id: post.userId._id,
        email: post.userId.email,
        username: post.userId.username,
        profilePicURL: post.userId.profilePicURL,
        dateOfBirth: post.userId.dateOfBirth,
        roles: post.userId.roles,
      },
      tags: post.tags.map((tag: any) => ({
        id: tag._id,
        emoji: tag.emoji,
        name: tag.name,
      })),
    });
  }

  return responseMsg(res, {
    status: 200,
    error: false,
    msg: `Retrived ${posts.length} posts successfully`,
    data: { posts },
  });
};
