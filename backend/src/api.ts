import express from "express";
import cors from "cors";
import { router as mainUserAuthRouter } from "./routes/main-user-auth";

// App
export const app = express();

// Middlewares
app.use(cors());
app.use(express.json()); // for parsing incoming data

// Test api routes
// app.get("/", (_, res) => res.send("hello world"));

/// Routes
app.use("/api/main-user-auth", mainUserAuthRouter);
