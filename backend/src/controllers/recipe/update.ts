import { Request, Response } from "express";
import { runAsync } from "../../utils";
import formidable, { File } from "formidable";
import { v4 } from "uuid";
import { bucket } from "../../firebase";
import { responseMsg } from "../json-response";
import _ from "lodash";

/// Send ingredients in form data in the text form given below
/// ingredients
/// [{"name": "salt", "description": "Little salt", "quantity": "Little salt"}, {"name": "salt", "description": "Little salt", "quantity": "Little salt"}]
/// Also send categories in form data in the text form as given below
/// categories
/// ["6138407f6b5436edd3415e6a", "61386910b033172f938b5427"]
async function updateRecipe(req: Request, res: Response) {
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

      if (fields.categories) {
        try {
          fields.categories = JSON.parse(fields.categories as string);
        } catch (er) {
          return responseMsg(res, {
            status: 400,
            message: "Wrong format used for sending categories",
          });
        }
      }

      if (fields.ingredients) {
        try {
          fields.ingredients = JSON.parse(fields.ingredients as string);
        } catch (er) {
          return responseMsg(res, {
            status: 400,
            message: "Wrong format used for sending ingredients",
          });
        }
      }

      let recipe = req.recipe;
      recipe = _.extend(recipe, fields);

      /// Save cover img in firebase storage
      const { coverImg } = files;
      if (coverImg) {
        const userId = req.profile._id;
        const filename = (coverImg as File).name;

        const uuid = v4();
        const destination = `recipe-cover-imgs/${userId}/${recipe._id}/${filename}`;

        /// Delete photo
        /// Note: Be careful with deleteFiles, if empty string
        /// is passed to prefix then it will delete everything
        /// in the bucket
        const [_deleteResult, deleteErr] = await runAsync(
          bucket.deleteFiles({
            prefix: `recipe-cover-imgs/${userId}/${recipe._id}`,
          })
        );

        if (deleteErr)
          return responseMsg(res, {
            status: 400,
            message: "Failed to delete recipe cover image",
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

        recipe.coverImgURL = photoURL;
      }

      const [savedRecipe, e] = await runAsync(recipe.save());
      console.log(e);
      if (e)
        return responseMsg(res, {
          status: 400,
          message: "Could not update recipe",
        });

      return responseMsg(res, {
        status: 200,
        error: false,
        message: "Successfully updated the recipe",
        data: {
          post: {
            _id: savedRecipe._id,
            title: savedRecipe.title,
            description: savedRecipe.description,
            coverImgURL: savedRecipe.coverImgURL,
            readTime: savedRecipe.readTime,
            categories: savedRecipe.categories,
            ingredients: savedRecipe.ingredients,
            author: savedRecipe.author,
          },
        },
      });
    }
  );
}

export default updateRecipe;
