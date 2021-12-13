import { Request, Response } from "express";
import User, { UserDocument } from "../models/user";
import { Controller, responseMsg, responseMsgs, runAsync } from "../utils";
import * as jsonwebtoken from "jsonwebtoken";

/**
 * Create new user
 *
 * @remarks
 *
 * Shape of req.body will be
 * - username
 * - email
 * - dateOfBirth
 * - password
 *
 * User data is not returned after successful sign up
 *
 * @todo
 * - Add some check in req.body to take only those values needed for User creation
 */
export const signup: Controller = async (req, res) => {
  // Check if the user exists or not
  const [count, err1] = await runAsync(
    User.find({ email: req.body.email }).limit(1).count().exec()
  );
  if (err1) return responseMsg(res);
  if (count !== 0) return responseMsg(res, { msg: "Email is already used" });

  // Saving the user in the db
  const [user, err2] = await runAsync(new User(req.body).save());
  if (err2 || !user) return responseMsg(res);
  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Account created successfully",
  });
};

/**
 * JWT login user in the backend
 *
 * @remarks
 *
 * Shape of req.body i.e. things needed for logging in the user are
 * - email
 * - password
 */
export const login: Controller = async (req, res) => {
  // Check whether the user exists
  const [data, err] = await runAsync(
    User.findOne({ email: req.body.email }).exec()
  );

  if (err) return responseMsg(res);
  else if (!data) return responseMsg(res, { msg: responseMsgs.NO_USER });
  const user: UserDocument = data;

  // Authentication
  if (!user.authenticate(req.body.password))
    return responseMsg(res, { status: 401, msg: "Wrong password" });

  // Adding auth cookie
  const token = jsonwebtoken.sign({ _id: user._id }, process.env.SECRET_KEY);
  res.cookie("token", token, { expires: new Date(Number(new Date()) + 9999) });

  user.encryptPassword = undefined;
  user.salt = undefined;

  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Successfully logged in",
    data: {
      token,
      user: {
        id: user._id,
        email: user.email,
        username: user.username,
        profilePicURL: user.profilePicURL,
        dateOfBirth: user.dateOfBirth,
        roles: user.roles,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      },
    },
  });
};

/**
 * Logout user in backend
 */
export const logout = (_: Request, res: Response) => {
  res.clearCookie("token");
  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "User logged out",
  });
};
