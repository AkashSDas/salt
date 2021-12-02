import { Document, model, Schema } from "mongoose";
import { ProductDocument } from "./product";
import { UserDocument } from "./user";
import MongoPaging from "mongo-cursor-pagination";

/**
 * Model Purpose
 * When a user purchase 1 or multiple products, a order is created for each
 * each unique product with quantity that they're pruchased at that time
 */

export type ProductOrderDocument = Document & {
  productId: ProductDocument;
  userId: UserDocument;
  sellerId: UserDocument;
  quantity: number;
  price: number; // price of single quantity
};

const ProductOrderSchema = new Schema<ProductOrderDocument>(
  {
    productId: { type: Schema.Types.ObjectId, ref: "Product", required: true },
    userId: { type: Schema.Types.ObjectId, ref: "User", required: true },
    sellerId: { type: Schema.Types.ObjectId, ref: "User", required: true },
    quantity: { type: Number, required: true },
    price: { type: Number, required: true },
  },
  { timestamps: true }
);

// Pagination
ProductOrderSchema.plugin(MongoPaging.mongoosePlugin, {
  name: "paginateProductOrder",
});

const ProductOrder = model<ProductOrderDocument>(
  "ProductOrder",
  ProductOrderSchema
);
export default ProductOrder;
