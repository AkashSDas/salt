import { Router } from "express";
import createBlogPost from "../controllers/blog-post/create";
import { getMainUserById } from "../controllers/main-user/middlewares";

export const router = Router();

/// Params
router.param("userId", getMainUserById);

/// Routes
router.post("/:userId", createBlogPost);
