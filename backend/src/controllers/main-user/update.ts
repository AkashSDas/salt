import { Request, Response } from "express";
import MainUser, { MainUserDocument } from "../../models/main-user";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

async function updateUser(req: Request, res: Response) {
  const [data, err] = await runAsync(
    MainUser.findByIdAndUpdate(req.profile._id, req.body, { new: true }).exec()
  );

  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Failed to update the user",
    });

  if (!data)
    return responseMsg(res, {
      status: 400,
      message: "User does not exists",
    });

  /// User was updated, return updated user
  const user: MainUserDocument = data;
  user.salt = undefined;
  user.encryptPassword = undefined;
  return responseMsg(res, {
    status: 200,
    error: false,
    message: "User updated successfully",
    data: { updatedUser: user },
  });
}

export default updateUser;
