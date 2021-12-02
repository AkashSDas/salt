import { Request, Response } from "express";
import { bucket } from "../../firebase";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

async function deleteRecipe(req: Request, res: Response) {
  const recipe = req.recipe;
  const userId = req.profile._id;

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

  /// Delete mongodb document
  const [data, err] = await runAsync(recipe.deleteOne({ _id: recipe._id }));
  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Failed to delete recipe",
    });

  if (!data)
    return responseMsg(res, {
      status: 400,
      message: "Recipe does not exists",
    });

  return responseMsg(res, {
    status: 200,
    error: false,
    message: "Successfully deleted recipe",
    data: { deletedRecipe: data },
  });
}

export default deleteRecipe;
