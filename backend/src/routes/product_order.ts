/**
 * Base route for tags is `/product-order`
 */

import { Router } from "express";
import { createProduct } from "../controllers/product";
import { isAuthenticated, isLoggedIn } from "../middlewares/auth";
import { validationCheck } from "../middlewares/express_validation";
import { getUserById } from "../middlewares/user";
import { productOrderValidation } from "../validators";

export const router = Router();

/**
 * Params
 */
router.param("userId", getUserById);

/**
 * Routes
 */

// Create product order
router.post(
  "/:userId",
  isLoggedIn,
  isAuthenticated,
  productOrderValidation,
  validationCheck,
  createProduct
);
