import { Router } from "express";
import { isAuthenticated, isSignedIn } from "../controllers/auth/middlewares";
import { getMainUserById } from "../controllers/main-user/middlewares";
import createProduct from "../controllers/product/create";
import deleteProduct from "../controllers/product/delete";
import getAllProducts from "../controllers/product/get-all-products";
import { getProductById } from "../controllers/product/middlewares";
import updateProduct from "../controllers/product/update";

export const router = Router();

/// Params
router.param("userId", getMainUserById);
router.param("productId", getProductById);

/// Routes
router.post("/:userId", isSignedIn, isAuthenticated, createProduct);
router.put("/:productId/:userId", isSignedIn, isAuthenticated, updateProduct);
router.delete(
  "/:productId/:userId",
  isSignedIn,
  isAuthenticated,
  deleteProduct
);
router.get("/", getAllProducts);
