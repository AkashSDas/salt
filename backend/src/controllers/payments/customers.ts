import { Request, Response } from "express";
import { createSetupIntent } from "../../stripe-payments/customers";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

/**
 * Create setup intent for future use of customer card
 */
export async function createSetupIntentForUser(req: Request, res: Response) {
  const userId = req.profile._id;
  const [intent, err] = await runAsync(createSetupIntent(userId));
  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Failed to setup intent",
    });

  return responseMsg(res, {
    status: 200,
    error: false,
    message: "Successfully created setup intent",
    data: { setup_intent: intent },
  });
}
