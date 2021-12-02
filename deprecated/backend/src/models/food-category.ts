import { Document, Schema, model } from "mongoose";

export type FoodCategoryDocument = Document & {
  emoji: string;
  name: string;
  description: string;
};

export const FoodCategorySchema = new Schema<FoodCategoryDocument>({
  emoji: {
    type: String,
    required: true,
    unique: true,
    maxlength: 16,
    trim: true,
  },
  name: {
    type: String,
    required: true,
    unique: true,
    maxlength: 16,
    trim: true,
  },
  description: {
    type: String,
    required: true,
    maxlength: 1024,
    trim: true,
  },
});

const FoodCategory = model<FoodCategoryDocument>(
  "FoodCategory",
  FoodCategorySchema
);
export default FoodCategory;
