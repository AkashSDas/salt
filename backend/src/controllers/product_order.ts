import { Controller, responseMsg, runAsync } from "../utils";
import ProductOrder, { ProductOrderDocument } from "../models/product_order";
import Feedback from "../models/feedback";

/**
 * Get user's product order (paginated)
 *
 * @remarks
 * Use this in conjunction with:
 * - `getUserById` middleware which will set `req.profile`
 *
 * @todos
 * - Handle condition where the user's had purchased the product in past but currently
 * its deleted. One way to handle this is user cannot delete products and update quantity
 * left to 0 if they don't want to sell things and in regular interval delete products with
 * 0 quantity left.
 */
export const getUserProductOrders: Controller = async (req, res) => {
  const user = req.profile;
  const next = req.query.next;
  const LIMIT = 4;
  const limit = req.query.limit ? parseInt(req.query.limit as string) : LIMIT;

  const [data, err1] = await runAsync(
    (ProductOrder as any).paginateProductOrder({
      query: { userId: user._id },
      limit: limit,
      paginatedField: "updatedAt",
      next,
    })
  );

  if (err1) return responseMsg(res);
  if (!data)
    return responseMsg(res, {
      status: 200,
      error: false,
      msg: "You haven't purchased anything",
      data: { orders: [] },
    });

  let orders = [];
  for (let i = 0; i < data.results.length; i++) {
    // Populating product order
    const [o1, err2] = await runAsync(
      ProductOrder.populate(data.results[i], "productId")
    );
    if (err2) return responseMsg(res);

    const [o2, err3] = await runAsync(
      ProductOrder.populate(o1, "productId.userId productId.tags")
    );
    if (err3) return responseMsg(res);
    const order: ProductOrderDocument = o2;

    // Get user's feedback on this product for this order
    const [feedback, err4] = await runAsync(
      Feedback.findOne(
        {
          userId: user._id,
          productId: order.productId._id,
          orderProductId: order._id,
        },
        "_id rating comment"
      ).exec()
    );
    if (err4) return responseMsg(res);
    orders.push({
      feedback: feedback
        ? {
            id: feedback._id,
            rating: feedback.rating,
            comment: feedback.comment,
          }
        : null,
      order: {
        id: order._id,
        quantity: order.quantity,
        price: order.price, // price of individual product
        product: {
          id: order.productId._id,
          title: order.productId.title,
          description: order.productId.description,
          info: order.productId.info,
          price: order.productId.price,
          coverImgURLs: order.productId.coverImgURLs,
          quantityLeft: order.productId.quantityLeft,
          user: {
            id: order.productId.userId._id,
            email: order.productId.userId.email,
            username: order.productId.userId.username,
            profilePicURL: order.productId.userId.profilePicURL,
            dateOfBirth: order.productId.userId.dateOfBirth,
            roles: order.productId.userId.roles,
          },
          tags: order.productId.tags.map((tag: any) => ({
            id: tag._id,
            emoji: tag.emoji,
            name: tag.name,
            description: tag.description,
          })),
        },
      },
    });
  }

  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Successfully retrieved orders",
    data: {
      orders,
      previous: data.previous,
      hasPrevious: data.hasPrevious,
      next: data.next,
      hasNext: data.hasNext,
    },
  });
};
