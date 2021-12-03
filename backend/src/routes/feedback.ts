/**
 * Base route for tags is `/feedback`
 */

import { Router } from "express";
import {
  createFeedback,
  deleteFeedback,
  updateFeedback,
} from "../controllers/feedback";
import { isAuthenticated, isLoggedIn } from "../middlewares/auth";
import { validationCheck } from "../middlewares/express_validation";
import { getFeedbackById } from "../middlewares/feedback";
import { getProductById } from "../middlewares/product";
import { getUserById } from "../middlewares/user";
import { feedbackValidation } from "../validators";

export const router = Router();

/**
 * Params
 */
router.param("userId", getUserById);
router.param("productId", getProductById);
router.param("feedbackId", getFeedbackById);

/**
 * Routes
 */

// Create feedback
router.post(
  "/:userId/:productId",
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
