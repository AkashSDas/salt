/**
 * Base route for tags is `/feedback`
 */

import { Router } from "express";
import {
  createFeedback,
  deleteFeedback,
  getProductFeedbackOverview,
  getFeedbacksOnProductWithoutPagination,
  updateFeedback,
  feedbackDummyData,
} from "../controllers/feedback";
import { isAuthenticated, isLoggedIn } from "../middlewares/auth";
import { validationCheck } from "../middlewares/express_validation";
import { getFeedbackById } from "../middlewares/feedback";
import { getProductById } from "../middlewares/product";
import { getProductOrderById } from "../middlewares/product_order";
import { getUserById, isAdmin } from "../middlewares/user";
import { feedbackValidation } from "../validators";

export const router = Router();

/**
 * Params
 */
router.param("userId", getUserById);
router.param("productId", getProductById);
router.param("orderId", getProductOrderById);
router.param("feedbackId", getFeedbackById);

/**
 * Routes
 */

// Create feedback
router.post(
  "/:userId/:orderId/:productId",
  isLoggedIn,
  isAuthenticated,
  feedbackValidation,
  validationCheck,
  createFeedback
);

// Update post
router.put("/:userId/:feedbackId", isLoggedIn, isAuthenticated, updateFeedback);

// Delete post
router.delete(
  "/:userId/:feedbackId",
  isLoggedIn,
  isAuthenticated,
  deleteFeedback
);

// Get product feedbacks overview
router.get("/:productId/overview", getProductFeedbackOverview);

// Get product feedbacks without pagination
router.get("/:productId", getFeedbacksOnProductWithoutPagination);

router.get(
  "/user/:userId",
  isLoggedIn,
  isAuthenticated,
  isAdmin,
  feedbackDummyData
);
