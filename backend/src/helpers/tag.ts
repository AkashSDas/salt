import Tag from "../models/tag";
import { runAsync } from "../utils";

/**
 * Check whether the given tag exists in tags collection
 *
 * @param name - name of the tag (its unique in Tag's model)
 *
 * @returns
 * Array of 2 elements - [data, err] (in our case data will be either 0 if the
 * doc doesn't exists or 1 if it does exists)
 */
export const checkTagExists = async (name: string) => {
  return await runAsync(Tag.find({ name: name }).limit(1).count().exec());
};
