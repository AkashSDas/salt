import { Router } from "express";
import { isAuthenticated, isSignedIn } from "../controllers/auth/middlewares";
import { getMainUserById } from "../controllers/main-user/middlewares";
import createOrder from "../controllers/order/create";
import {
  pushOrderInPurchaseList,
  updateProductStock,
} from "../controllers/product/middlewares";

export const router = Router();

/// Params
router.param("userId", getMainUserById);

/// Routes

/**
 * The flow for this request is that \
 * - User auth will be checked and if authenticated then
 * - Products will be pushed into user's purchases list
 * - Quantity left and sold for each product will be updated
 * - This order will be saved in the database
 */
router.post(
  "/",
  isSignedIn,
  isAuthenticated,
  pushOrderInPurchaseList,
  updateProductStock,
  createOrder
);
