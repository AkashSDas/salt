import { addRole, roleExists } from "../helpers/user";
import Seller from "../models/seller";
import { Controller, responseMsg, runAsync } from "../utils";

/**
 * Make user an admin
 *
 * @todo
 * - Add something like `secret code` using which the user can become admin and not directly
 */
export const becomeAdmin: Controller = async (req, res) => {
  const exists = roleExists(req, "admin");
  if (exists)
    return responseMsg(res, {
      status: 200,
      error: false,
      msg: "You're already an admin",
    });

  // Make user an admin
  const isSuccess = await addRole(req, "admin");
  if (!isSuccess) return responseMsg(res);
  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "You're now an admin",
  });
};

/**
 * Add seller role to user's roles and create seller doc for this user
 *
 * @remarks
 *
 * The operation of adding seller role to user's role and creating seller doc for
 * the user are separate and ideally if one fails and the other one should also fail
 * but currently there is option for bulk write across multiple collections in mongoDB.
 * So this is **current issue in this controller**
 *
 * The shape of req.body will be
 * - bio
 * - phoneNumber
 * - address
 *
 * @todo
 * - Add something like `secret code` using which the user can become seller and not directly
 */
export const becomeSeller: Controller = async (req, res) => {
  const exists = roleExists(req, "seller");
  if (exists)
    return responseMsg(res, {
      status: 200,
      error: false,
      msg: "You're already a seller",
    });

  // Make user a seller
  const isSuccess = await addRole(req, "Seller");
  if (!isSuccess) return responseMsg(res);

  // Create seller doc
  const [seller, err] = await runAsync(
    new Seller({ userId: req.profile._id, ...req.body }).save()
  );
  if (err || !seller) responseMsg(res);

  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "You're now a seller",
  });
};
