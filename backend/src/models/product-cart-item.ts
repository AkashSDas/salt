import { Document, Schema } from "mongoose";
import { ProductDocument } from "./product";

export type ProductCartItemDocument = Document & {
  quantity: number;
  price: number;
  product: ProductDocument;
  createdAt: Date;
  updatedAt: Date;
};

export const ProductCartItemSchema = new Schema<ProductCartItemDocument>(
  {
    quantity: { type: Number, required: true },
    price: { type: Number, required: true },
    product: { type: Schema.Types.ObjectId, ref: "Product", required: true },
  },
  { timestamps: true }
);
