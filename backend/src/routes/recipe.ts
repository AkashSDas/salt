import { Router } from "express";
import { isAuthenticated, isSignedIn } from "../controllers/auth/middlewares";
import { getMainUserById } from "../controllers/main-user/middlewares";
import createRecipe from "../controllers/recipe/create";
import deleteRecipe from "../controllers/recipe/delete";
import getAllRecipes from "../controllers/recipe/get-all-recipes";
import getRecipe from "../controllers/recipe/get-recipe";
import { getRecipeById } from "../controllers/recipe/middlewares";
import updateRecipe from "../controllers/recipe/update";

export const router = Router();

/// Params
router.param("userId", getMainUserById);
router.param("recipeId", getRecipeById);

/// Routes
router.post("/:userId", isSignedIn, isAuthenticated, createRecipe);
router.get("/", getAllRecipes);
router.get("/:recipeId", getRecipe);
router.put("/:recipeId/:userId", isSignedIn, isAuthenticated, updateRecipe);
router.delete("/:recipeId/:userId", isSignedIn, isAuthenticated, deleteRecipe);
