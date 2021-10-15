import { stripe } from "..";
import { runAsync } from "../utils";
import { getOrCreateCustomer } from "./customers";

/**
 * For this the user has to be authenticated
 */
export async function createPaymentIntentAndCharge(
  userId: string,
  amount: number,
  payment_method: string
) {
  const [customer, _err] = await runAsync(getOrCreateCustomer(userId));
  const paymentIntent = await stripe.paymentIntents.create({
    amount,
    customer: customer.id,
    payment_method,
    currency: "inr",
    off_session: true,
    confirm: true,
  });
  return paymentIntent;
}
