import { Document, model, Schema } from "mongoose";
import { MainUserDocument } from "./main-user";
import MongoPaging from "mongo-cursor-pagination";
import { IngredientSchema } from "./ingredient";

export type RecipeDocument = Document & {
  title: string;
  description: string;
  content: string;
  coverImgURL?: string;
  readTime: number;
  createdAt: Date;
  updatedAt: Date;
  ingredients: any;
  categories: any;
  author: MainUserDocument;
};

const RecipeSchema = new Schema<RecipeDocument>(
  {
    title: { type: String, required: true, trim: true, maxlength: 256 },
    description: { type: String, required: true, maxlength: 2048, trim: true },
    content: { type: String, required: true, trim: true },
    coverImgURL: { type: String },
    readTime: { type: Number, required: true },
    categories: {
      type: [{ type: Schema.Types.ObjectId, ref: "FoodCategory" }],
      required: true,
    },
    ingredients: {
      type: [IngredientSchema],
    },
    author: { type: Schema.Types.ObjectId, ref: "MainUser", required: true },
  },
  { timestamps: true }
);

RecipeSchema.plugin(MongoPaging.mongoosePlugin, { name: "paginateRecipe" });

const Recipe = model<RecipeDocument>("Recipe", RecipeSchema);
export default Recipe;
