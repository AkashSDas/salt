/**
 * Base route for user is `/user`
 */

import { Router } from "express";
import { becomeAdmin, becomeSeller } from "../controllers/user";
import { isAuthenticated, isLoggedIn } from "../middlewares/auth";
import { validationCheck } from "../middlewares/express_validation";
import { getUserById } from "../middlewares/user";
import { sellerValidation } from "../validators";

export const router = Router();

/**
 * Params
 */
router.param("userId", getUserById);

/**
 * Routes
 */

// Become admin
router.post("/:userId/roles/admin", isLoggedIn, isAuthenticated, becomeAdmin);

// Become seller
router.post(
  "/:userId/roles/seller",
  isLoggedIn,
  isAuthenticated,
  sellerValidation,
  validationCheck,
  becomeSeller
);
