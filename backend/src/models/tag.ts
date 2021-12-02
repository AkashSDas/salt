import { Document, model, Schema } from "mongoose";

/**
 * Model Purpose
 *
 * This can be a tag on product or post or any other thing. These tags
 * will be created by admin only
 */

export type TagDocument = Document & {
  emoji: string;
  name: string;
  description: string;
};

const TagSchema = new Schema<TagDocument>(
  {
    emoji: { type: String, required: true, trim: true },
    name: { type: String, required: true, unique: true, trim: true },
    description: { type: String, required: true, trim: true },
  },
  { timestamps: true }
);

const Tag = model<TagDocument>("Tag", TagSchema);
export default Tag;
