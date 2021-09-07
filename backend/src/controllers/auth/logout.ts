import { Request, Response } from "express";
import { responseMsg } from "../json-response";

function logout(_: Request, res: Response) {
  res.clearCookie("token");
  return responseMsg(res, {
    status: 200,
    error: false,
    message: "Successfully logged out",
  });
}

export default logout;
