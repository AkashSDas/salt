/**
 * Model purpose
 *
 * Product model represent individual product that can be sold. The info field
 * should have markdown text as they can be more expressive with additional
 * information, product details, and much more
 *
 * The coverImgURLs field is required and must have atleast one img url. Now this
 * field is typed optional in ProductDocument and is not set required in ProductSchema,
 * The reason being once the product object is create (not saved as doc) then that product
 * id is used to create folder in firebase storage and there the imgs are saved and then
 * the urls of the saved imgs are set to coverImgURLs and then the product object is saved
 * and product doc is created. If the coverImgURLs is already set then we've to set atleast
 * an empty array to avoid error of to providing coverImgURLs.
 *
 * Alternatively a way can be while create product object set it to array with only one
 * value which being default cover img and then get id, save imgs and update the field
 * before create that doc (This method is not used, the above mehtod is used)
 */

import { Document, model, Schema } from "mongoose";
import { TagDocument } from "./tag";
import { UserDocument } from "./user";
import MongoPaging from "mongo-cursor-pagination";

export type ProductDocument = Document & {
  title: string;
  description: string;
  info: string; // markdown
  price: number;
  coverImgURLs?: string[];
  userId: UserDocument;
  tags: TagDocument[];
  quantityLeft: number;
};

const ProductSchema = new Schema<ProductDocument>(
  {
    title: {
      type: String,
      required: true,
      trim: true,
      maxlength: 2048,
      index: true,
    },
    description: {
      type: String,
      required: true,
      trim: true,
      maxlength: 4096,
      index: true,
    },
    info: { type: String, required: true, trim: true, index: true },
    price: { type: Number, required: true, default: 0, min: 0 },
    coverImgURLs: {
      type: [String],
      default: [process.env.DEFAULT_USER_PROFILE_PIC_URL],
    },
    userId: { type: Schema.Types.ObjectId, ref: "User", required: true },
    tags: {
      type: [{ type: Schema.Types.ObjectId, ref: "Tag" }],
      required: true,
    },
    quantityLeft: { type: Number, required: true, default: 0, min: 0 },
  },
  { timestamps: true }
);

// Pagination
ProductSchema.plugin(MongoPaging.mongoosePlugin, { name: "paginateProduct" });

ProductSchema.index({ title: "text", description: "text", info: "text" });
const Product = model<ProductDocument>("Product", ProductSchema);
Product.createIndexes();

export default Product;
