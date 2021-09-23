import Stripe from "stripe";
import { stripe } from "../..";
import MainUser from "../../models/main-user";
import { runAsync } from "../../utils";

export async function getOrCreateCustomer(
  userId: string,
  params?: Stripe.CustomerCreateParams
) {
  const [userSnapshot, error] = await runAsync(
    MainUser.findById(userId).exec()
  );
  if (error) return [null, error];

  const { stripeCustomerId, email } = userSnapshot;

  /// If user is not a stripe customer then making him/her
  if (!stripeCustomerId) {
    const customer = await stripe.customers.create({
      email,
      metadata: {
        mongodbId: userSnapshot._id,
      },
      ...params,
    });

    /// Only drawback of adding the stripeCustomerId in the mongodb user
    /// doc is that the data become stale
    const [_newUserSnapshot, err] = await runAsync(
      MainUser.findByIdAndUpdate(
        userSnapshot._id,
        { stripeCustomerId: customer.id },
        { new: true }
      ).exec()
    );

    if (err) return [null, err];
    return customer;
  } else {
    return (await stripe.customers.retrieve(
      stripeCustomerId
    )) as Stripe.Customer;
  }
}
