import { extend } from "lodash";
import Feedback from "../models/feedback";
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
