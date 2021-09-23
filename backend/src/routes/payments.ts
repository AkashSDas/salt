import { Router } from "express";
import { isAuthenticated, isSignedIn } from "../controllers/auth/middlewares";
import { getMainUserById } from "../controllers/main-user/middlewares";
import { createPaymentIntentAndChargeUser } from "../controllers/payments/payments";

export const router = Router();

/// Router params
router.param("userId", getMainUserById);

/// Router routes
router.post(
  "/stripe/payment/:userId",
  isSignedIn,
  isAuthenticated,
  createPaymentIntentAndChargeUser
);
