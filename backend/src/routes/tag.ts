/**
 * Base route for tags is `/tags`
 */

import { Router } from "express";
import { createTag, deleteTag, getAllTags, getTag } from "../controllers/tag";
import { isAuthenticated, isLoggedIn } from "../middlewares/auth";
import { validationCheck } from "../middlewares/express_validation";
import { getTagById } from "../middlewares/tag";
import { getUserById, isAdmin } from "../middlewares/user";
import { tagValidation } from "../validators";

export const router = Router();

/**
 * Params
 */
router.param("userId", getUserById);
router.param("tagId", getTagById);

/**
 * Routes
 */

// Get all tags
router.get("/", getAllTags);

// Get a tag
router.get("/:tagMongoId", getTag);

// Create tag when requested by an admin
router.post(
  "/:userId",
  isLoggedIn,
  isAuthenticated,
  isAdmin,
  tagValidation,
  validationCheck,
  createTag
);

// Delete tag when requested by an admin
router.delete(
  "/:userId/:tagId",
  isLoggedIn,
  isAuthenticated,
  isAdmin,
  deleteTag
);
