import express from "express";
import cors from "cors";
import { router as mainUserAuthRouter } from "./routes/main-user-auth";
import { router as foodCategoryRouter } from "./routes/food-category";
import { router as blogPostRouter } from "./routes/blog-post";
import { router as recipeRouter } from "./routes/recipe";
import { router as productRouter } from "./routes/product";

// App
export const app = express();

// Middlewares
app.use(cors());
app.use(express.json()); // for parsing incoming data

// Test api routes
// app.get("/", (_, res) => res.send("hello world"));

/// Routes
app.use("/api/main-user-auth", mainUserAuthRouter);
app.use("/api/food-category", foodCategoryRouter);
app.use("/api/blog-post", blogPostRouter);
app.use("/api/recipe", recipeRouter);
app.use("/api/product", productRouter);
