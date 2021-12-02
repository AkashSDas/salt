import { Request, Response } from "express";
import MainUser, { MainUserDocument } from "../../models/main-user";
import { runAsync } from "../../utils";
import { expressValidatorErrorResponse, responseMsg } from "../json-response";
import * as jsonwebtoken from "jsonwebtoken";

interface LoginRequest extends Request {
  body: {
    email: string;
    password: string;
  };
}

async function login(req: LoginRequest, res: Response) {
  const [errors, jsonRes] = expressValidatorErrorResponse(req, res);
  if (errors) return jsonRes;

  const { email, password } = req.body;

  /// When using `exec` there is no error returned, just user returned
  /// is null indicating user was not found
  let [data, error] = await runAsync(MainUser.findOne({ email }).exec());

  /// If data i.e. user is null then user doesn't exists
  if (error || !data)
    return responseMsg(res, {
      status: 400,
      message: "User does not exists",
    });

  const user: MainUserDocument = data;
  if (!user.authenticate(password))
    return responseMsg(res, {
      status: 401,
      message: "Password does not match",
    });

  /// So now user does exist and so logging in

  const token = jsonwebtoken.sign({ _id: user._id }, process.env.SECRET_KEY);
  res.cookie("token", token, {
    /// for dev purpose keep expiry date long, otherwise keep it short
    expires: new Date(Number(new Date()) + 9999),
  });

  return responseMsg(res, {
    status: 200,
    error: false,
    message: "Successfully logged in",
    data: {
      token,
      user: {
        _id: user._id,
        username: user.username,
        email: user.email,
        role: user.role,
        profilePicURL: user.profilePicURL,
      },
    },
  });
}

export default login;

/// Here type intersection won't work for adding properties to body
/// as body is defined in Request type. So what happens is that body
/// will be of type any. Here beast will have all of its properties
/// So better way is use interface and extend properties
///
/// Another way if the properties are needed to be used globally by
/// Request type then follow the below stack overflow post
/// https://stackoverflow.com/questions/37377731/extend-express-request-object-using-typescript/51050139
/// Also this way (not global.d.ts or types but extending interface of Request in
/// express-serve-static-core is done in `backend_playground/`)
// type LoginRequest = Request & {
//   body: {
//     email: string;
//     password: string;
//   };
//   beast: {
//     email: string;
//     password: string;
//   };
//   email: string;
// };
