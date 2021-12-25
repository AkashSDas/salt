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
