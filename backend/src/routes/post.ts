/**
 * Base route for tags is `/post`
 */

import { Router } from "express";
import { createPost, deletePost, updatePost } from "../controllers/post";
import { isAuthenticated, isLoggedIn } from "../middlewares/auth";
import { validationCheck } from "../middlewares/express_validation";
import { getPostById } from "../middlewares/post";
import { getUserById } from "../middlewares/user";
import { postValidation } from "../validators";

export const router = Router();

/**
 * Params
 */
router.param("userId", getUserById);
router.param("postId", getPostById);

/**
 * Routes
 */

// Create post
router.post(
  "/:userId",
  isLoggedIn,
  isAuthenticated,
  postValidation,
  validationCheck,
  createPost
);

// Update post
router.put("/:userId/:postId", isLoggedIn, isAuthenticated, updatePost);

// Delete post
router.delete("/:userId/:postId", isLoggedIn, isAuthenticated, deletePost);
