import { Request, Response } from "express";
import { createPaymentIntentAndCharge } from "../../stripe-payments/payments";
import { responseMsg } from "../json-response";

export async function createPaymentIntentAndChargeUser(
  req: Request,
  res: Response
) {
  const userId = req.profile._id;
  const { amount, payment_method } = req.body;

  if (!amount || !payment_method)
    return responseMsg(res, {
      status: 400,
      message: "Amount and/or payment method are missing",
    });

  const paymentIntent = await createPaymentIntentAndCharge(
    userId,
    amount,
    payment_method
  );

  return responseMsg(res, {
    status: 200,
    error: false,
    message: "Payment made successfully",
    data: { paymentIntent },
  });
}
