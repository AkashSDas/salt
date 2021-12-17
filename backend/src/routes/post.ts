/**
 * Base route for tags is `/post`
 */

import { Router } from "express";
import { createPost, deletePost, updatePost } from "../controllers/post";
import { isAuthenticated, isLoggedIn } from "../middlewares/auth";
import { getPostById } from "../middlewares/post";
import { getUserById } from "../middlewares/user";

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
router.post("/:userId", isLoggedIn, isAuthenticated, createPost);

// Update post
router.put("/:userId/:postId", isLoggedIn, isAuthenticated, updatePost);

// Delete post
router.delete("/:userId/:postId", isLoggedIn, isAuthenticated, deletePost);
