import { Request, Response } from "express";
import { MainUserDocument } from "../../models/main-user";
import { responseMsg } from "../json-response";

interface IGetUserRequest extends Request {
  profile: MainUserDocument;
}

/// Some user data are irrelevant for client, so removing it from
/// profile in req which contains user data
function getMainUser(req: IGetUserRequest, res: Response) {
  req.profile.salt = undefined;
  req.profile.encryptPassword = undefined;
  req.profile.createdAt = undefined;
  req.profile.updatedAt = undefined;

  return responseMsg(res, {
    status: 200,
    error: false,
    message: "User data",
    data: {
      user: req.profile,
    },
  });
}

export default getMainUser;
