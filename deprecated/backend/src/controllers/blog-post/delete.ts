import { Request, Response } from "express";
import { bucket } from "../../firebase";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

async function deleteBlogPost(req: Request, res: Response) {
  const blogPost = req.blogPost;
  const userId = req.profile._id;

  /// Delete photo
  /// Note: Be careful with deleteFiles, if empty string
  /// is passed to prefix then it will delete everything
  /// in the bucket
  const [_deleteResult, deleteErr] = await runAsync(
    bucket.deleteFiles({
      prefix: `blog-post-cover-imgs/${userId}/${blogPost._id}`,
    })
  );

  /// If there's only one file to be deleted then use the below method
  ///   const [__, deleteErr] = await runAsync(
  ///     bucket.file(`blog-post-cover-imgs/${userId}/${blogPost._id}/${filename}`).delete()
  ///   );

  if (deleteErr)
    return responseMsg(res, {
      status: 400,
      message: "Failed to delete post cover image",
    });

  /// Delete mongodb document
  const [data, err] = await runAsync(blogPost.deleteOne({ _id: blogPost._id }));
  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Failed to delete post",
    });

  if (!data)
    return responseMsg(res, {
      status: 400,
      message: "Post does not exists",
    });

  return responseMsg(res, {
    status: 200,
    error: false,
    message: "Successfully deleted post",
    data: { deletedPost: data },
  });
}

export default deleteBlogPost;
