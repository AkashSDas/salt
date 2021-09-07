import { Router } from "express";
import { check } from "express-validator";
import login from "../controllers/auth/login";
import logout from "../controllers/auth/logout";
import signup from "../controllers/auth/signup";

export const router = Router();

/// Logout
router.get("/logout", logout);

/// Signup
const signupValidations = [
  check("email", "Email is required").isEmail(),
  check("username", "Username should have atleast 3 character").isLength({
    min: 3,
  }),
  check("password", "Password should have atleast 6 characters").isLength({
    min: 6,
  }),
];

router.post("/signup", signupValidations, signup);

/// Login
const loginValidations = [
  check("email", "Email is required").isEmail(),
  check("password", "Password should have atleast 6 characters").isLength({
    min: 6,
  }),
];

router.post("/login", loginValidations, login);
