import { Request, Response } from "express";
import { runAsync } from "../../utils";
import formidable, { File } from "formidable";
import { v4 } from "uuid";
import { bucket } from "../../firebase";
import { responseMsg } from "../json-response";
import _ from "lodash";

async function updateBlogPost(req: Request, res: Response) {
  let form = new formidable.IncomingForm({ keepExtensions: true });

  form.parse(
    req,
    async (err: any, fields: formidable.Fields, files: formidable.Files) => {
      if (err) {
        // If user is coming till here after passing all vaidators
        // then chances are high that the problem is in file itself
        return responseMsg(res, {
          status: 400,
          message: "There is some problem with the image file",
        });
      }

      fields.categories = JSON.parse(fields.categories as string);

      let blogPost = req.blogPost;
      blogPost = _.extend(blogPost, fields);

      /// Save cover img in firebase storage
      const { coverImg } = files;
      if (coverImg) {
        const userId = req.profile._id;
        const filename = (coverImg as File).name;

        const uuid = v4();
        const destination = `blog-post-cover-imgs/${userId}/${blogPost._id}/${filename}`;

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

        const [_uploadResult, error] = await runAsync(
          bucket.upload((coverImg as File).path, {
            destination,
            metadata: {
              contentType: "image/png",
              metadata: {
                firebaseStorageDownloadTokens: uuid,
              },
            },
          })
        );

        if (error)
          return responseMsg(res, {
            status: 400,
            message: "Could not save cover image",
          });

        const photoURL =
          "https://firebasestorage.googleapis.com/v0/b/" +
          bucket.name +
          "/o/" +
          encodeURIComponent(destination) +
          "?alt=media&token=" +
          uuid;

        blogPost.coverImgURL = photoURL;
      }

      const [savedBlogPost, e] = await runAsync(blogPost.save());
      console.log(e);
      if (e)
        return responseMsg(res, {
          status: 400,
          message: "Could not update post",
        });

      return responseMsg(res, {
        status: 200,
        error: false,
        message: "Successfully updated the post",
        data: {
          post: {
            _id: savedBlogPost._id,
            title: savedBlogPost.title,
            description: savedBlogPost.description,
            coverImgURL: savedBlogPost.coverImgURL,
            readTime: savedBlogPost.readTime,
            categories: savedBlogPost.categories,
            author: savedBlogPost.author,
          },
        },
      });
    }
  );
}

export default updateBlogPost;
