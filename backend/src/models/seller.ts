/**
 * Model purpose
 *
 * This model represents a seller who intends to sell products.
 * The bio field will be used as a markdown text holder.
 * User and Seller will have one-to-one relation. A user can have only
 * one seller account and once the user's seller account is created
 * then that user's `seller` role should be added to that user's roles
 */

import { Document, model, Schema } from "mongoose";
import { UserDocument } from "./user";
import MongoPaging from "mongo-cursor-pagination";

export type SellerDocument = Document & {
  userId: UserDocument;
  bio: string; // markdown
  phoneNumber: number;
  address: string;
};

const SellerSchema = new Schema<SellerDocument>(
  {
    userId: { type: Schema.Types.ObjectId, ref: "User", required: true },
    bio: { type: String, required: true, trim: true, maxlength: 2048 },
    phoneNumber: { type: Number, required: true },
    address: { type: String, required: true, trim: true, maxlength: 2048 },
  },
  { timestamps: true }
);

// Pagination
SellerSchema.plugin(MongoPaging.mongoosePlugin, { name: "paginateSeller" });

const Seller = model<SellerDocument>("Seller", SellerSchema);
export default Seller;
