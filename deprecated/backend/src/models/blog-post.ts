import { Document, model, Schema } from "mongoose";
import { MainUserDocument } from "./main-user";
import MongoPaging from "mongo-cursor-pagination";

export type BlogPostDocument = Document & {
  title: string;
  description: string;
  content: string;
  coverImgURL?: string;
  readTime: number;
  createdAt: Date;
  updatedAt: Date;
  categories: any;
  author: MainUserDocument;
};

const BlogPostSchema = new Schema<BlogPostDocument>(
  {
    title: { type: String, required: true, maxlength: 256, trim: true },
    description: { type: String, required: true, maxlength: 2048, trim: true },
    content: { type: String, required: true, trim: true },
    coverImgURL: { type: String },
    readTime: { type: Number, required: true },
    categories: {
      type: [{ type: Schema.Types.ObjectId, ref: "FoodCategory" }],
      required: true,
    },
    author: { type: Schema.Types.ObjectId, ref: "MainUser", required: true },
  },
  { timestamps: true }
);

BlogPostSchema.plugin(MongoPaging.mongoosePlugin, { name: "paginateBlogPost" });

const BlogPost = model<BlogPostDocument>("BlogPost", BlogPostSchema);
export default BlogPost;
