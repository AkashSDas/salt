import { Request, Response } from "express";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";
import MongoPaging from "mongo-cursor-pagination";
import { MainUserDocument } from "../../models/main-user";
import Recipe, { RecipeDocument } from "../../models/recipe";

async function getAllRecipesOfSingleUser(req: Request, res: Response) {
  const next = req.query.next;

  const LIMIT = 1;
  const limit = req.query.limit ? parseInt(req.query.limit as string) : LIMIT;

  const profile = req.profile;

  const [data, err] = await runAsync(
    MongoPaging.find(Recipe.collection, {
      query: { author: profile._id },
      paginatedField: "updatedAt",
      limit,
      next,
    })
  );

  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Failed to retrive recipes",
    });

  /// since traditional for loop is more performant then forEach and
  /// here we can have lots of data to loop, so tranditional for loop
  /// is used
  const recipes = [];
  for (let i = 0; i < data.results.length; i++) {
    const [p, err] = await runAsync(
      Recipe.populate(data.results[i], "author categories")
    );

    if (err)
      return responseMsg(res, {
        status: 400,
        message: "Failed to retrive recipe",
      });

    const recipe: RecipeDocument = p;

    let author: MainUserDocument = recipe.author;
    author.salt = undefined;
    author.encryptPassword = undefined;
    author.purchases = undefined;

    recipes.push({
      _id: recipe._id,
      title: recipe.title,
      description: recipe.description,
      content: recipe.content,
      readTime: recipe.readTime,
      categories: recipe.categories,
      ingredients: recipe.ingredients,
      coverImgURL: recipe.coverImgURL,
      author: recipe.author,
      createdAt: recipe.createdAt,
      updatedAt: recipe.updatedAt,
    });
  }

  return responseMsg(res, {
    status: 200,
    error: false,
    message: `Retrived ${recipes.length} recipes successfully`,
    data: {
      recipes,
      previous: data.previous,
      hasPrevious: data.hasPrevious,
      next: data.next,
      hasNext: data.hasNext,
    },
  });
}

export default getAllRecipesOfSingleUser;
