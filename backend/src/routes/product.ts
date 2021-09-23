import { Router } from "express";
import { isAuthenticated, isSignedIn } from "../controllers/auth/middlewares";
import { getMainUserById } from "../controllers/main-user/middlewares";
import createProduct from "../controllers/product/create";
import { getProductById } from "../controllers/product/middlewares";
import updateProduct from "../controllers/product/update";

export const router = Router();

/// Params
router.param("userId", getMainUserById);
router.param("productId", getProductById);

/// Routes
router.post("/:userId", isSignedIn, isAuthenticated, createProduct);
router.put("/:productId/:userId", isSignedIn, isAuthenticated, updateProduct);
