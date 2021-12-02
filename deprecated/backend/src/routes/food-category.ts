import { Router } from "express";
import { isAuthenticated, isSignedIn } from "../controllers/auth/middlewares";
import createCategory from "../controllers/food-category/create";
import deleteCategory from "../controllers/food-category/delete";
import getAllCategories from "../controllers/food-category/get-all-categories";
import getCategory from "../controllers/food-category/get-category";
import { getCategoryById } from "../controllers/food-category/middlewares";
import updateCategory from "../controllers/food-category/update";
import { getMainUserById } from "../controllers/main-user/middlewares";

export const router = Router();

/// Params
router.param("userId", getMainUserById);
router.param("foodCategoryId", getCategoryById);

/// Routes
router.post("/:userId", isSignedIn, isAuthenticated, createCategory);

router.put(
  "/:foodCategoryId/:userId",
  isSignedIn,
  isAuthenticated,
  updateCategory
);

router.delete(
  "/:foodCategoryId/:userId",
  isSignedIn,
  isAuthenticated,
  deleteCategory
);

router.get(
  "/:foodCategoryId/:userId",
  isSignedIn,
  isAuthenticated,
  getCategory
);

router.get("/", getAllCategories);
