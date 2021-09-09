import { Router } from "express";
import { isAuthenticated, isSignedIn } from "../controllers/auth/middlewares";
import { getMainUserById } from "../controllers/main-user/middlewares";
import createRecipe from "../controllers/recipe/create";

export const router = Router();

/// Params
router.param("userId", getMainUserById);

/// Routes
router.post("/:userId", isSignedIn, isAuthenticated, createRecipe);
