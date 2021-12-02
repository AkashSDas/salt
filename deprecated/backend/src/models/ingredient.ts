import { Document, Schema, model } from "mongoose";

export type IngredientDocument = Document & {
  name: string;
  description: string;
  quantity: string;
};

export const IngredientSchema = new Schema<IngredientDocument>({
  name: { type: String, required: true, trim: true, maxlength: 1024 },
  description: {
    type: String,
    required: true,
    trim: true,
    maxlength: 1024 * 4,
  },
  quantity: { type: String, required: true, trim: true, maxlength: 1024 },
});

const Ingredient = model<IngredientDocument>("Ingredient", IngredientSchema);
export default Ingredient;
