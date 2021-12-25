/**
 * Model purpose
 *
 * Users who have purchased a product can rate the it and give their comment
 * on that product.
 */

import { Document, model, Schema } from "mongoose";
import { ProductDocument } from "./product";
import { ProductOrderDocument } from "./product_order";
import { UserDocument } from "./user";

export type FeedbackDocument = Document & {
  userId: UserDocument;
  productId: ProductDocument;
  productOrderId: ProductOrderDocument;
  rating: number; // ranging from 0-5 (discret number)
  comment: string;
};

const FeedbackSchema = new Schema<FeedbackDocument>({
  userId: { type: Schema.Types.ObjectId, ref: "User", required: true },
  productId: { type: Schema.Types.ObjectId, ref: "Product", required: true },
  productOrderId: {
    type: Schema.Types.ObjectId,
    ref: "ProductOrder",
    required: true,
  },
  rating: { type: Number, required: true, min: 0, max: 5 },
  comment: { type: String, required: true, trim: true },
});

const Feedback = model<FeedbackDocument>("Feedback", FeedbackSchema);
export default Feedback;
