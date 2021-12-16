import { listPaymentMethods } from "../payments/customer";
import { Controller, responseMsg } from "../utils";

/**
 * Get payment sources associated to the user
 *
 * @remarks
 *
 * Use this in conjunction with
 * - getUserById which will set `req.profile`
 */
export const getUserPaymentCards: Controller = async (req, res) => {
  const user = req.profile;
  const cards = await listPaymentMethods(user._id);
  if (!cards) return responseMsg(res);
  return responseMsg(res, {
    error: false,
    status: 200,
    msg: "Successfully retrived user's payment cards",
    data: { cards: cards.data },
  });
};
