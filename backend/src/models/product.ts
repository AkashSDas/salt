import { Document, model, Schema } from "mongoose";
import MongoPaging from "mongo-cursor-pagination";

export type ProductDocument = Document & {
  title: string;
  description: string;
  coverImgURLs?: string[];
  quantity_left: number;
  quantity_sold: number;
  price: number;
  createdAt: Date;
  updatedAt: Date;
};

const ProductSchema = new Schema<ProductDocument>(
  {
    title: { type: String, required: true, maxlength: 1024, trim: true },
    description: {
      type: String,
      required: true,
      maxlength: 1024 * 5,
      trim: true,
    },
    coverImgURLs: { type: [String], required: true, minlength: 1 },
    quantity_left: { type: Number, required: true },
    quantity_sold: { type: Number, default: 0 },
    price: { type: Number, required: true },
  },
  { timestamps: true }
);

ProductSchema.plugin(MongoPaging.mongoosePlugin, { name: "paginateProduct" });

const Product = model<ProductDocument>("Product", ProductSchema);
export default Product;
