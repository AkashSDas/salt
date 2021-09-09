import { Request, Response } from "express";
import { runAsync } from "../../utils";
import formidable, { File } from "formidable";
import { v4 } from "uuid";
import { bucket } from "../../firebase";
import { responseMsg } from "../json-response";
import Recipe from "../../models/recipe";

/// Send ingredients in form data in the text form given below
/// ingredients
/// [{"name": "salt", "description": "Little salt", "quantity": "Little salt"}, {"name": "salt", "description": "Little salt", "quantity": "Little salt"}]
/// Also send categories in form data in the text form as given below
/// categories
/// ["6138407f6b5436edd3415e6a", "61386910b033172f938b5427"]
async function createRecipe(req: Request, res: Response) {
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

      const { title, description, content, readTime: readTimeStr } = fields;
      const {
        categories: categoriesStr,
        ingredients: ingredientsStr,
        author,
      } = fields;
      const { coverImg } = files;

      if (
        !title ||
        !description ||
        !content ||
        !readTimeStr ||
        !categoriesStr ||
        !author ||
        !coverImg ||
        !ingredientsStr
      ) {
        return responseMsg(res, {
          status: 400,
          message: "Please include all the fields",
        });
      }

      let categories;
      try {
        categories = JSON.parse(categoriesStr as string);
      } catch (er) {
        return responseMsg(res, {
          status: 400,
          message: "Wrong format used for sending categories",
        });
      }

      let ingredients;
      try {
        ingredients = JSON.parse(ingredientsStr as string);
      } catch (er) {
        return responseMsg(res, {
          status: 400,
          message: "Wrong format used for sending ingredients",
        });
      }

      let readTime;
      try {
        readTime = parseFloat(readTimeStr as string);
      } catch (er) {
        return responseMsg(res, {
          status: 400,
          message: "Read time should be a number",
        });
      }

      const data = {
        title,
        description,
        content,
        categories,
        readTime,
        author,
        ingredients,
      };

      let recipe = new Recipe(data);

      /// Save cover img in firebase storage
      const userId = req.profile._id;
      const filename = (coverImg as File).name;

      const uuid = v4();
      const destination = `recipe-cover-imgs/${userId}/${recipe._id}/${filename}`;
      const [_, error] = await runAsync(
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

      const [savedRecipe, e] = await runAsync(recipe.save());
      if (e)
        return responseMsg(res, {
          status: 400,
          message: "Could not save recipe",
        });

      return responseMsg(res, {
        status: 200,
        error: false,
        message: "Successfully saved recipe",
        data: {
          post: {
            _id: savedRecipe._id,
            title: savedRecipe.title,
            description: savedRecipe.description,
            coverImgURL: savedRecipe.coverImgURL,
            readTime: savedRecipe.readTime,
            categories: savedRecipe.categories,
            author: savedRecipe.author,
            ingredients: savedRecipe.ingredients,
          },
        },
      });
    }
  );
}

export default createRecipe;
