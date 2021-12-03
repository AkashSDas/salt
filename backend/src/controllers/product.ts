import { IncomingForm } from "formidable";
import { createProductFormCallback } from "../helpers/product";
import { Controller } from "../utils";

/**
 * Create product
 *
 * @remarks
 *
 * Shape of req.body
 * - title
 * - description
 * - info
 * - price
 * - tags
 * - quantityLeft
 * - coverImgs - array of img files which displays product
 */
export const createProduct: Controller = async (req, res) => {
  let form = new IncomingForm({ keepExtensions: true, multiples: true });
  form.parse(req, (err, fields, files) =>
    createProductFormCallback(req, res, err, fields, files)
  );
};
