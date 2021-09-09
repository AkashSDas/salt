import { Router } from "express";
import { isAuthenticated, isSignedIn } from "../controllers/auth/middlewares";
import createBlogPost from "../controllers/blog-post/create";
import deleteBlogPost from "../controllers/blog-post/delete";
import getAllBlogPosts from "../controllers/blog-post/get-all-blog-posts";
import getBlogPost from "../controllers/blog-post/get-blog-post";
import { getBlogPostById } from "../controllers/blog-post/middlewares";
import updateBlogPost from "../controllers/blog-post/update";
import { getMainUserById } from "../controllers/main-user/middlewares";

export const router = Router();

/// Params
router.param("userId", getMainUserById);
router.param("blogPostId", getBlogPostById);

/// Routes
router.post("/:userId", createBlogPost);
router.put("/:blogPostId/:userId", isSignedIn, isAuthenticated, updateBlogPost);
router.get("/", getAllBlogPosts);
router.get("/:blogPostId", getBlogPost);
router.delete(
  "/:blogPostId/:userId",
  isSignedIn,
  isAuthenticated,
  deleteBlogPost
);
