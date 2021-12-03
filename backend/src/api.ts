import cors from "cors";
import express from "express";
import { router as authRouter } from "./routes/auth";
import { router as userRouter } from "./routes/user";
import { router as tagRouter } from "./routes/tag";
import { router as postRouter } from "./routes/post";
import { router as productRouter } from "./routes/product";

// App
export const app = express();

// Middlewares
app.use(cors());
app.use(express.json()); // for parsing incoming data

// Test api routes
// app.get("/", (_, res) => res.send("hello world"));

// Routes
app.use("/api/auth", authRouter);
app.use("/api/user", userRouter);
app.use("/api/tag", tagRouter);
app.use("/api/post", postRouter);
app.use("/api/product", productRouter);
