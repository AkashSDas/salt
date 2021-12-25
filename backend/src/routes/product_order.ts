/**
 * Base route for tags is `/product-order`
 */

import { Router } from "express";
import { getUserProductOrders } from "../controllers/product_order";
import { isAuthenticated, isLoggedIn } from "../middlewares/auth";
import { getUserById } from "../middlewares/user";

export const router = Router();

/**
 * Params
 */
router.param("userId", getUserById);

/**
 * Routes
 */

// Get all user's order (paginated)
router.get("/:userId", isLoggedIn, isAuthenticated, getUserProductOrders);
