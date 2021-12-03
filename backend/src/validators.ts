/**
 * This file has all the express validators for req.body used
 * in this project
 */

import { check } from "express-validator";

export const signupValidation = [
  check("email", "Email is required").exists(),
  check("email", "Email has wrong format").isEmail(),
  check("username", "Username is required").exists(),
  check("username", "Username should be atleast 3 characters").isLength({
    min: 3,
  }),
  check("dateOfBirth", "Date of birth is required").exists(),
  check("dateOfBirth", "Date of birth has wrong format").isDate(),
  check("password", "Password is required").exists(),
  check("password", "Password should be atleast 6 characters").isLength({
    min: 6,
  }),
];

export const loginValidation = [
  check("email", "Email is required").exists(),
  check("email", "Email has wrong format").isEmail(),
  check("password", "Password is required").exists(),
  check("password", "Password should be atleast 6 characters").isLength({
    min: 6,
  }),
];

export const sellerValidation = [
  check("bio", "Bio required").exists(),
  check("bio", "Bio should be atleast of 10 characters").isLength({ min: 10 }),
  check("phoneNumber", "Phone number required").exists(),
  check("phoneNumber", "Invalid phone number").isMobilePhone("en-IN"),
  check("address", "Address required").exists(),
  check("address", "Address should be atleast of 60 characters").isLength({
    min: 60,
  }),
];

export const tagValidation = [
  check("name", "Name is required").exists(),
  check("name", "Name should be atleast 3 characters").isLength({ min: 3 }),
  check("emoji", "Emoji is required").exists(),
  check("emoji", "Emoji should be atmost 4 characters").isLength({ max: 4 }),
  check("description", "Description is required").exists(),
  check("description", "Description should be atleast 10 characters").isLength({
    min: 10,
  }),
];

/**
 * @todo
 * Add custom validator to validate tags array of mongoIds
 */
export const postValidation = [
  check("title", "Title is required").exists(),
  check("title", "Title should be atleast 3 characters").isLength({ min: 3 }),
  check("description", "Description is required").exists(),
  check("description", "Description should be atleast 10 characters").isLength({
    min: 10,
  }),
  check("content", "Content is required").exists(),
  check("content", "Content should be atleast 10 characters").isLength({
    min: 10,
  }),
  check("tags", "Atleast one tag is needed required").exists(),
  check("tags", "Wrong format used for tags").isArray(),
];

/**
 * @todo
 * Add custom validator to validate tags array of mongoIds
 */
export const productValidation = [
  check("title", "Title is required").exists(),
  check("title", "Title should be atleast 3 characters").isLength({ min: 3 }),
  check("description", "Description is required").exists(),
  check("description", "Description should be atleast 10 characters").isLength({
    min: 10,
  }),
  check("info", "Info is required").exists(),
  check("info", "Info should be atleast 10 characters").isLength({
    min: 10,
  }),
  check("price", "Price is required").exists(),
  check("price", "Price should be a positive number").isFloat({ min: 0 }),
  check("tags", "Atleast one tag is needed required").exists(),
  check("tags", "Wrong format used for tags").isArray(),
  check("quantityLeft", "Quantity left is required").exists(),
  check("quantityLeft", "Quantity left should be a positive number").isFloat({
    min: 0,
  }),
  check("coverImgs", "Atleast one product images is needed").exists(),
  check("coverImgs", "Wrong format of product images").isArray(),
];

/**
 * @todo
 * - Add custom validator for products
 * - Add more validator for payment method
 */
export const productOrderValidation = [
  check("products", "Atleast one product is required").exists(),
  check("products", "Wrong format of products").isArray(),
  check("payment_method", "Payment method is required").exists(),
  check("payment_method", "Invalid payment method").isString(),
];
