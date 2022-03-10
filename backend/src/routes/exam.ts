import { Router } from "express";

import { getProductOrders } from "../controllers/exam";

export const router = Router();

router.get("/", getProductOrders);
