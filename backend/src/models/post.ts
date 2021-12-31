/**
 * Model purpose
 *
 * This model represents articles that user can write. userId is the author's id
 * who will create that post. The content should be in markdown format. This model
 * can be used to write about recipes as the content field be used for markdown
 * text
 */

import { Document, model, Schema } from "mongoose";
import { TagDocument } from "./tag";
import { UserDocument } from "./user";
import MongoPaging from "mongo-cursor-pagination";

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
    content: { type: String, required: true, trim: true, index: true },
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

PostSchema.index({ title: "text", description: "text", content: "text" });
const Post = model<PostDocument>("Post", PostSchema);
Post.createIndexes();

export default Post;
