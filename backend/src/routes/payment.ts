/**
 * Base route for tags is `/payment`
 */

import { Router } from "express";
import { getUserPaymentCards } from "../controllers/payment";
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

// Get user's payment cards
router.get("/wallet/:userId", isLoggedIn, isAuthenticated, getUserPaymentCards);
