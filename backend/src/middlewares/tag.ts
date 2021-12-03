import Tag, { TagDocument } from "../models/tag";
import { IdMiddleware, responseMsg, runAsync } from "../utils";

/**
 * Get tag (if exists) and set it to req.tag
 *
 * @params
 * id: tag mongodb id
 */
export const getTagById: IdMiddleware = async (req, res, next, id) => {
  const [data, err] = await runAsync(Tag.findOne({ _id: id }).exec());
  if (err) return responseMsg(res);
  else if (!data) return responseMsg(res, { msg: "Tag doesn't exists" });
  const t: TagDocument = data;
  req.tag = t;
  next();
};
