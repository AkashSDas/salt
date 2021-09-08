import { NextFunction, Request, Response } from "express";
import jwt from "express-jwt";
import { responseMsg } from "../json-response";

/// Protected routes will use this middleware
/// `auth` will be the user property
export const isSignedIn = jwt({
  secret: process.env.SECRET_KEY,
  userProperty: "auth",
  algorithms: ["HS256"],
});

/// Custom middlewares ///

/// Authenticating logged in and request sending user
export function isAuthenticated(
  req: Request,
  res: Response,
  next: NextFunction
) {
  /// Will be set by router.param('userId') where we will user by id
  const profile = req.profile;

  /// auth property will be set by isSignedIn middleware
  const auth = req.auth;

  /// using double = since we are just checking the value and not the object (as they are different)
  const check = profile && auth && profile._id == auth._id;
  if (!check)
    return responseMsg(res, {
      status: 403,
      message: "Access denied",
    });

  next();
}

/// Check Admin
export function isAdmin(req: Request, res: Response, next: NextFunction) {
  /// Regular user
  if (req.profile.role === 0)
    return responseMsg(res, {
      status: 403,
      message: "You are not admin, Access denied",
    });

  next();
}
