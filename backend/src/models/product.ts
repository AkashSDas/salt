import { Document, model, Schema } from "mongoose";
import { TagDocument } from "./tag";
import { UserDocument } from "./user";
import MongoPaging from "mongo-cursor-pagination";

/**
 * Model Purpose
 * Products that are for sale, user's can buy and sell.
 */

export type ProductDocument = Document & {
  title: string;
  description: string;
  info: string; // markdown
  price: number;
  coverImgURLs: string[];
  userId: UserDocument;
  tags: TagDocument[];
  quantityLeft: number;
};

const ProductSchema = new Schema<ProductDocument>(
  {
    title: { type: String, required: true, trim: true, maxlength: 2048 },
    description: { type: String, required: true, trim: true, maxlength: 4096 },
    info: { type: String, required: true, trim: true },
    price: { type: Number, required: true },
    coverImgURLs: {
      type: [String],
      required: true,
      default: [process.env.DEFAULT_USER_PROFILE_PIC_URL],
    },
    userId: { type: Schema.Types.ObjectId, ref: "User", required: true },
    tags: {
      type: [{ type: Schema.Types.ObjectId, ref: "Tag" }],
      required: true,
    },
    quantityLeft: { type: Number, required: true, default: 0 },
  },
  { timestamps: true }
);

// Pagination
ProductSchema.plugin(MongoPaging.mongoosePlugin, { name: "paginateProduct" });

const Product = model<ProductDocument>("Product", ProductSchema);
export default Product;
