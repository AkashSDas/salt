/**
 * Tag for now are meant to be created by admins only.
 * So before performing any CUD(create, update, delete) tag
 * opertation check whether the user is an admin or not
 *
 * Tag are going to be already set by admin so the seller or anyone
 * can directly select from the given options
 */

import { checkTagExists } from "../helpers/tag";
import Tag from "../models/tag";
import { Controller, responseMsg, runAsync } from "../utils";

/**
 * Create tag
 *
 * @remarks
 * Shape of req.body should be
 * - name
 * - emoji
 * - description
 */
export const createTag: Controller = async (req, res) => {
  const [count, err1] = await checkTagExists(req.body.name);
  if (err1) return responseMsg(res);
  if (count !== 0) return responseMsg(res, { msg: "Name is already used" });

  // Create new doc
  const [t, err2] = await runAsync(new Tag(req.body).save());
  if (err2 || !t) return responseMsg(res);
  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Sccuessfully created tag",
    data: { tag: t },
  });
};

/**
 * Delete tag
 *
 * @remarks
 * This should be used in conjunction with getTagById middleware
 * which will set req.tag
 */
export const deleteTag: Controller = async (req, res) => {
  const t = req.tag;
  const [, err] = await runAsync(t.deleteOne({ _id: t._id }));
  if (err) return responseMsg(res);
  return responseMsg(res, {
    status: 200,
    error: false,
    msg: "Successfully deleted tag",
  });
};

/**
 * Get all tags without pagination
 */
export const getAllTags: Controller = async (_, res) => {
  const [ts, err] = await runAsync(Tag.find().exec());
  if (err) return responseMsg(res);
  if (!ts) return responseMsg(res, { msg: "No tags available" });

  const tags = ts.map((tag) => ({
    id: tag._id,
    emoji: tag.emoji,
    name: tag.name,
    description: tag.description,
    createdAt: tag.createdAt,
    updatedAt: tag.updatedAt,
  }));

  return responseMsg(res, {
    status: 200,
    error: false,
    msg: `Successfully retrieved ${tags.length} tags`,
    data: { tags },
  });
};

/**
 * Get a tag
 */
export const getTag: Controller = async (req, res) => {
  const [tag, err] = await runAsync(
    Tag.findOne({ _id: req.params.tagMongoId }).exec()
  );
  if (err) return responseMsg(res);
  if (!tag) return responseMsg(res, { msg: "There's no such tag" });

  return responseMsg(res, {
    status: 200,
    error: false,
    msg: `Tag retrieved successfully`,
    data: {
      tag: {
        id: tag._id,
        emoji: tag.emoji,
        name: tag.name,
        description: tag.description,
        createdAt: tag.createdAt,
        updatedAt: tag.updatedAt,
      },
    },
  });
};
