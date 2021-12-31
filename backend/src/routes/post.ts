/**
 * Base route for tags is `/post`
 */

import { Router } from "express";
import {
  createPost,
  deletePost,
  getPosts,
  getPostsForTag,
  getPostsOfUser,
  getPostsWithTags,
  searchPosts,
  updatePost,
} from "../controllers/post";
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

// Search posts
router.post("/search", searchPosts);

// Create post
router.post("/:userId", isLoggedIn, isAuthenticated, createPost);

// Update post
router.put("/:userId/:postId", isLoggedIn, isAuthenticated, updatePost);

// Delete post
router.delete("/:userId/:postId", isLoggedIn, isAuthenticated, deletePost);

// Get all posts paginated
router.get("/", getPosts);

// Get all posts with a tag (without pagination)
router.get("/tag/:tagId", getPostsForTag);

// Get all posts of a user (with pagination)
router.get("/:userId", isLoggedIn, isAuthenticated, getPostsOfUser);

// Get all posts with tags (without pagination)
router.get("/tags/:tagIds", getPostsWithTags);
