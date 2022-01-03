import { extend } from "lodash";
import Feedback from "../models/feedback";
import ProductOrder from "../models/product_order";
import { Controller, responseMsg, runAsync } from "../utils";

/**
 * Create a feedback
 *
 * @remarks
 *
 * This controller should be used in conjunction with params
 * - userId - isAuthenticated which will set req.profile
 * - productId - getProductById which will set req.product
 *
 * Shape of req.body will be
 * - rating (discret number between 1 to 5)
 * - comment
 *
 * @todos
 * - Check if the feedback is already created, if yes then don't create a new one
 */
export const createFeedback: Controller = async (req, res) => {
  const user = req.profile;
  const product = req.product;
  const order = req.productOrder;

  const [feedback, err] = await runAsync(
    new Feedback({
      userId: user._id,
      productId: product._id,
      productOrderId: order._id,
      ...req.body,
    }).save()
  );

  if (err || !feedback) return responseMsg(res);
  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Successfully create feedback",
    data: { feedback },
  });
};

/**
 * Update feedback
 *
 * @remarks
 *
 * Use this in conjunction with param
 * - feedbackId - getFeedbackById which will set req.feedback
 *
 * Shape of req.body will (all of them are optional)
 * - rating
 * - comment
 *
 * @todo
 * - Check whether the user updating the feedback is the author that one
 * - Add check whether so that req.body should not have userId or productId as
 * they are set once and cannot be updated later on
 */
export const updateFeedback: Controller = async (req, res) => {
  let feedback = req.feedback;
  feedback = extend(feedback, req.body);
  const [updatedFeedback, err] = await runAsync(feedback.save());

  if (err || !feedback) return responseMsg(res);
  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Successfully updated feedback",
    data: { feedback: updatedFeedback },
  });
};

/**
 * Delete feedback
 *
 * @remarks
 *
 * Use this in conjunction with param
 * - feedbackId - getFeedbackById which will set req.feedback
 *
 * @todo
 * - Check whether the user updating the feedback is the author that one
 */
export const deleteFeedback: Controller = async (req, res) => {
  const feedback = req.feedback;
  const [, err] = await runAsync(feedback.deleteOne({ _id: feedback._id }));
  if (err) return responseMsg(res);
  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Successfully deleted the feedback",
  });
};

/**
 * Get product ratings overview
 *
 * @todos
 * - Handle errors
 */
export const getProductFeedbackOverview: Controller = async (req, res) => {
  const product = req.product;

  const [rating0, _err1] = await runAsync(
    Feedback.count({ productId: product._id, rating: 0 }).exec()
  );
  const [rating1, _err2] = await runAsync(
    Feedback.count({ productId: product._id, rating: 1 }).exec()
  );
  const [rating2, _err3] = await runAsync(
    Feedback.count({ productId: product._id, rating: 2 }).exec()
  );
  const [rating3, _err4] = await runAsync(
    Feedback.count({ productId: product._id, rating: 3 }).exec()
  );
  const [rating4, _err5] = await runAsync(
    Feedback.count({ productId: product._id, rating: 4 }).exec()
  );
  const [rating5, _err6] = await runAsync(
    Feedback.count({ productId: product._id, rating: 5 }).exec()
  );

  return responseMsg(res, {
    error: false,
    status: 200,
    msg: "Product feedback overview",
    data: {
      "0": rating0 ?? 0,
      "1": rating1 ?? 0,
      "2": rating2 ?? 0,
      "3": rating3 ?? 0,
      "4": rating4 ?? 0,
      "5": rating5 ?? 0,
    },
  });
};

/**
 * Get users feedback on a product (without pagination)
 */
export const getFeedbacksOnProductWithoutPagination: Controller = async (
  req,
  res
) => {
  const product = req.product;
  const [data, err] = await runAsync(
    Feedback.find({ productId: product._id }).populate("userId").exec()
  );
  if (err) return responseMsg(res);
  if (!data)
    return responseMsg(res, {
      error: false,
      status: 200,
      msg: "Retrieved all feedbacks for the product",
      data: { feedbacks: [] },
    });

  let feedbacks = [];
  for (let i = 0; i < data.length; i++) {
    const feedback = data[i];
    feedbacks.push({
      id: feedback._id,
      rating: feedback.rating,
      comment: feedback.comment,
      user: {
        id: feedback.userId._id,
        email: feedback.userId.email,
        username: feedback.userId.username,
        profilePicURL: feedback.userId.profilePicURL,
        dateOfBirth: feedback.userId.dateOfBirth,
        roles: feedback.userId.roles,
        createdAt: feedback.userId.createdAt,
        updatedAt: feedback.userId.updatedAt,
      },
    });
  }

  return responseMsg(res, {
    error: false,
    status: 200,
    msg: "Retrieved all feedbacks for the product",
    data: { feedbacks },
  });
};

/**
 * Create dummy feedbacks
 */
export const feedbackDummyData: Controller = async (req, res) => {
  const data = [
    "this cake is top-notch.",
    "i use it barely when i'm in my store.",
    "heard about this on powerviolence radio, decided to give it a try.",
    "My neighbor Elisha has one of these. She works as a fortune teller and she says it looks floppy.",
    "My co-worker Cato has one of these. He says it looks sopping.",
    "It only works when I'm Rwanda.",
    "i use it never when i'm in my nightclub.",
    "My co-worker Luka has one of these. He says it looks purple.",
    "It only works when I'm Bolivia.",
    "this cake is amiable.",
    "This cake works so well. It imperfectly improves my baseball by a lot.",
    "This cake works excessively well. It mortally improves my golf by a lot.",
    "I tried to hang it but got jelly bean all over it.",
    "i use it centenially when i'm in my greenhouse.",
    "i use it for 10 weeks when i'm in my jail.",
    "My neighbor Karly has one of these. She works as a gambler and she says it looks tall.",
    "this cake is smooth.",
    "This cake works quite well. It romantically improves my golf by a lot.",
    "works okay.",
    "My jaguar loves to play with it.",
    "The box this comes in is 5 inch by 6 mile and weights 15 ton!!",
    "The box this comes in is 4 mile by 5 inch and weights 19 megaton!",
    "I tried to maul it but got onion all over it.",
    "This cake works so well. It delightedly improves my football by a lot.",
    "It only works when I'm Argentina.",
    "heard about this on gypsy jazz radio, decided to give it a try.",
    "I saw one of these in Spratly Islands and I bought one.",
    "I tried to impale it but got fudge all over it.",
    "this cake is perplexed.",
    "My co-worker Luka has one of these. He says it looks purple.",
    "this cake is amiable.",
    "I saw one of these in Juan de Nova Island and I bought one.",
    "My co-worker Knute has one of these. He says it looks smoky.",
    "My penguin loves to play with it.",
    "i use it daily when i'm in my courthouse.",
    "My neighbor Lular has one of these. She works as a cake decorator and she says it looks ragged.",
    "this cake is vertical.",
    "this cake is ratty.",
    "The box this comes in is 5 inch by 6 mile and weights 15 ton!!",
    "The box this comes in is 3 kilometer by 5 inch and weights 13 ton.",
    "I saw one of these in Moldova and I bought one.",
    "I saw one of these in Kazakhstan and I bought one.",
    "The box this comes in is 3 meter by 5 foot and weights 11 kilogram.",
    "I tried to attack it but got meatball all over it.",
    "My neighbor Elisha has one of these. She works as a fortune teller and she says it looks floppy.",
    "heard about this on chicha radio, decided to give it a try.",
    "This cake works excessively well. It speedily improves my baseball by a lot.",
    "This cake works outstandingly well. It grudgingly improves my baseball by a lot.",
    "this cake is nifty.",
    "The box this comes in is 3 meter by 5 foot and weights 11 kilogram.",
  ];

  const [orders, _err1] = await runAsync(
    ProductOrder.find().populate("userId productId").exec()
  );

  for (let i = 0; i < orders.length; i++) {
    const rating = Math.floor(Math.random() * 6);
    const comment = data[Math.floor(Math.random() * data.length)];

    const doc = new Feedback({
      productId: orders[i].productId._id,
      userId: orders[i].userId._id,
      productOrderId: orders[i]._id,
      rating: rating,
      comment: comment,
    });
    await doc.save();
  }

  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Created dummy feedback orders",
  });
};
