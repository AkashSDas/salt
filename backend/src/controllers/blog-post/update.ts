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

      /// Currently unable to send array of object ids from postman
      /// using all the ways found (along with by Postman doc) only
      /// the last id was received in backend in the form of text (string)
      /// Way used was
      /// Key              |  Value
      /// categories       | 6138407f6b5436edd3415e6a
      /// categories       | 61386910b033172f938b5427
      ///
      /// Currently you've to send category ids in the form given below
      /// '6138407f6b5436edd3415e6a,61386910b033172f938b5427'
      /// i.e.
      /// Key              |  Value
      /// categories       | 6138407f6b5436edd3415e6a,61386910b033172f938b5427
      /// which is parsed here

      if (fields.categories) {
        try {
          fields.categories = (fields.categories as string).trim().split(",");
        } catch (er) {
          return responseMsg(res, {
            status: 400,
            message: "Wrong format used for sending categories",
          });
        }
      }

      /// Values in fields should be string or string[]
      /// so can't assign fields.readTime to number value
      /// But this shouldn't be a problem since if the value
      /// is something other than number then mongoose will throw
      /// an error for wrong type
      // if (fields.readTime) {
      //   try {
      //     fields.readTime = parseFloat(fields.readTime as string);
      //   } catch (er) {
      //     return responseMsg(res, {
      //       status: 400,
      //       message: "Read time should be a number",
      //     });
      //   }
      // }

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
        ///     bucket.file(`product-photos/${userId}/${product._id}/filename`).delete()
        ///   );

        if (deleteErr)
          return responseMsg(res, {
            status: 400,
            message: "Failed to delete product",
            // message: "Failed to delete product photo",
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
