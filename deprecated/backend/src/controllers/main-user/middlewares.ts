import { NextFunction, Request, Response } from "express";
import MainUser, { MainUserDocument } from "../../models/main-user";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

interface IGetUserByIdRequest extends Request {
  profile: MainUserDocument;
}

export async function getMainUserById(
  req: IGetUserByIdRequest,
  res: Response,
  next: NextFunction,
  userId: string
) {
  const [data, error] = await runAsync(MainUser.findById(userId).exec());
  if (error || !data)
    return responseMsg(res, {
      status: 400,
      message: "User does not exists",
    });

  const user: MainUserDocument = data;
  req.profile = user;
  next();
}
