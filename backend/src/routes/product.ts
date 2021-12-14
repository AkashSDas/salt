/**
 * Base route for tags is `/product`
 */

import { Router } from "express";
import {
  createProduct,
  deleteProduct,
  getProducts,
  getProductsForTag,
  purchaseProducts,
  updateProduct,
} from "../controllers/product";
import { isAuthenticated, isLoggedIn } from "../middlewares/auth";
import { validationCheck } from "../middlewares/express_validation";
import { getProductById } from "../middlewares/product";
import { getUserById, isSeller } from "../middlewares/user";
import { productValidation, productOrderValidation } from "../validators";

export const router = Router();

/**
 * Params
 */
router.param("userId", getUserById);
router.param("productId", getProductById);

/**
 * Routes
 */

// Create a product
router.post(
  "/:userId",
  isLoggedIn,
  isAuthenticated,
  isSeller,
  productValidation,
  validationCheck,
  createProduct
);

// Update product
router.put(
  "/:userId/:productId",
  isLoggedIn,
  isAuthenticated,
  isSeller,
  updateProduct
);

// Delete product
router.delete(
  "/:userId/:productId",
  isLoggedIn,
  isAuthenticated,
  isSeller,
  deleteProduct
);

// Purchase products
router.post(
  "/purchase/:userId",
  isLoggedIn,
  isAuthenticated,
  productOrderValidation,
  validationCheck,
  purchaseProducts
);

// Get all products - paginated
router.get("/", getProducts);

// Get all products having a tag - paginated
router.get("/tag/:tagId", getProductsForTag);
