import { Request, Response } from "express";
import Recipe, { RecipeDocument } from "../../models/recipe";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

async function getAllRecipes(req: Request, res: Response) {
  /// if their is next id then use it to get data from that document
  /// if it is undefined then paginateUser will give documents from start
  const next = req.query.next;

  const LIMIT = 1;
  const limit = req.query.limit ? parseInt(req.query.limit as string) : LIMIT;

  const [data, err] = await runAsync(
    await (Recipe as any).paginateRecipe({
      limit,
      paginatedField: "updatedAt",
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
    const [r, err] = await runAsync(
      Recipe.populate(data.results[i], "author categories")
    );

    if (err)
      return responseMsg(res, {
        status: 400,
        message: "Failed to retrive recipes",
      });

    const recipe: RecipeDocument = r;

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

export default getAllRecipes;
