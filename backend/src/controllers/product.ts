import { IncomingForm } from "formidable";
import {
  createProductFormCallback,
  updateProductFormCallback,
} from "../helpers/product";
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
 *
 * Only user with seller role can create product
 */
export const createProduct: Controller = async (req, res) => {
  let form = new IncomingForm({ keepExtensions: true, multiples: true });
  form.parse(req, (err, fields, files) =>
    createProductFormCallback(req, res, err, fields, files)
  );
};

/**
 * Update product
 *
 * @remarks
 *
 * Shape of req.body (all fields being optional)
 * - title
 * - description
 * - info
 * - price
 * - tags
 * - quantityLeft
 * - coverImgs - array of img files which displays product
 *
 * This current set of coverImgURLs which will be generated for this coverImgs
 * (if there) will replace the previous coverImgURLs
 *
 * User this in conjuntion with
 * - getProductById middleware which will set `rwq.product`
 *
 * @todo
 * - If coverImgs are updated then old imgs will be replace with these new imgs. So add
 * a feature when imgs can be added to existing imgs and individual img can be removed
 */
export const updateProduct: Controller = async (req, res) => {
  let form = new IncomingForm({ keepExtensions: true, multiples: true });
  form.parse(req, (err, fields, files) =>
    updateProductFormCallback(req, res, err, fields, files)
  );
};
