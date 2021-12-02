/**
 * Model purpose
 *
 * Tag model can be used for tags in blog post, product that are for sale,
 * or any other places
 */

import { Document, model, Schema } from "mongoose";

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
