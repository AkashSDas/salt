import { Document, model, Schema } from "mongoose";
import { MainUserDocument } from "./main-user";
import MongoPaging from "mongo-cursor-pagination";

import {
  ProductCartItemDocument,
  ProductCartItemSchema,
} from "./product-cart-item";

enum OrderStatusEnum {
  "Cancelled",
  "Delivered",
  "Shipped",
  "Dispatching",
  "Received",
}

export type OrderDocument = Document & {
  products: ProductCartItemDocument[];
  transactionId: { [key: string]: any };
  amount: number;
  address: string;
  status: string;
  user: MainUserDocument;
  createdAt: Date;
  updatedAt: Date;
};

const orderSchema = new Schema<OrderDocument>({
  products: { type: [ProductCartItemSchema], required: true },
  transactionId: {},
  amount: { type: Number, required: true },
  address: { type: String, required: true },
  status: {
    type: String,
    default: OrderStatusEnum.Dispatching.toString(),
    enum: Object.values(OrderStatusEnum),
  },
  user: { type: Schema.Types.ObjectId, ref: "User", required: true },
});

orderSchema.plugin(MongoPaging.mongoosePlugin, { name: "paginateOrder" });
export const Order = model<OrderDocument>("Order", orderSchema);
