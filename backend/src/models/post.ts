import { Document, model, Schema } from "mongoose";
import { TagDocument } from "./tag";
import { UserDocument } from "./user";
import MongoPaging from "mongo-cursor-pagination";

/**
 * Model Purpose
 * Articles, recipes or simply blog post is what this Post model is
 */

export type PostDocument = Document & {
  title: string;
  description: string;
  content: string; // markdown
  readTime: number;
  wordCount: number;
  published: boolean;
  coverImgURL: string;
  userId: UserDocument;
  tags: TagDocument[];
};

const PostSchema = new Schema<PostDocument>(
  {
    title: { type: String, required: true, trim: true, maxlength: 2048 },
    description: { type: String, required: true, trim: true, maxlength: 4096 },
    content: { type: String, required: true, trim: true },
    readTime: { type: Number, required: true },
    wordCount: { type: Number, required: true },
    published: { type: Boolean, required: true, default: false },
    coverImgURL: {
      type: String,
      required: true,
      default: process.env.DEFAULT_USER_PROFILE_PIC_URL,
    },
    userId: { type: Schema.Types.ObjectId, ref: "User", required: true },
    tags: {
      type: [{ type: Schema.Types.ObjectId, ref: "Tag" }],
      required: true,
    },
  },
  { timestamps: true }
);

// Pagination
PostSchema.plugin(MongoPaging.mongoosePlugin, { name: "paginatePost" });

const Post = model<PostDocument>("Post", PostSchema);
export default Post;
