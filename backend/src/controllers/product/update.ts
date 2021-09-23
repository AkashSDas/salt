import { Request, Response } from "express";
import formidable, { File } from "formidable";
import { responseMsg } from "../json-response";
import _ from "lodash";
import { runAsync } from "../../utils";
import { bucket } from "../../firebase";
import { v4 } from "uuid";

async function updateProduct(req: Request, res: Response) {
  let form = new formidable.IncomingForm({
    keepExtensions: true,
    multiples: true,
  });

  form.parse(
    req,
    async (err: any, fields: formidable.Fields, files: formidable.Files) => {
      if (err)
        return responseMsg(res, {
          status: 400,
          message: "There is some problem with the image files",
        });

      let product = req.product;
      //// NOTE: product sold cannot be directly updated here
      /// It is updated when product is sold
      /// Here setting quantity_sold as what's in the database and
      /// overwritting the value if user had sent
      fields.quantity_sold = req.product.quantity_sold;
      product = _.extend(product, fields);

      /// Save img in firebase
      const { coverImgs } = files;

      if (coverImgs) {
        const userId = req.profile._id;
        let imgURLs = [];

        /// NOTE: User have to re-upload all the imgs

        /// Delete all cover imgs
        /// Note: Be careful with deleteFiles, if empty string
        /// is passed to prefix then it will delete everything
        /// in the bucket
        const [_deleteResult, _deleteError] = await runAsync(
          bucket.deleteFiles({
            prefix: `products/${userId}/${product._id}`,
          })
        );

        if (_deleteError)
          return responseMsg(res, {
            status: 400,
            message: "Failed to delete product cover images",
          });

        /// Upload all imgs

        for await (const img of coverImgs as formidable.File[]) {
          const filename = (img as File).name;
          const uuid = v4();
          const destination = `products/${userId}/${product._id}/${filename}`;

          const [_, error] = await runAsync(
            bucket.upload((img as File).path, {
              destination,
              metadata: {
                contentType: "image/png",
                metadata: {
                  firebaseStorageDownloadTokens: uuid,
                },
              },
            })
          );

          if (error)
            return responseMsg(res, {
              status: 400,
              message: "Could not save cover image",
            });

          const photoURL =
            "https://firebasestorage.googleapis.com/v0/b/" +
            bucket.name +
            "/o/" +
            encodeURIComponent(destination) +
            "?alt=media&token=" +
            uuid;

          imgURLs.push(photoURL);
        }

        product.coverImgURLs = imgURLs;
      }

      const [savedProduct, e] = await runAsync(product.save());
      if (e)
        return responseMsg(res, {
          status: 400,
          message: "Could not save product",
        });

      return responseMsg(res, {
        status: 200,
        error: false,
        message: "Successfully updated product",
        data: {
          product: {
            id: savedProduct._id,
            title: savedProduct.title,
            description: savedProduct.description,
            coverImgURLs: savedProduct.coverImgURLs,
            quantity_left: savedProduct.quantity_left,
            quantity_sold: savedProduct.quantity_sold,
            price: savedProduct.price,
            createdAt: savedProduct.createdAt,
            updatedAt: savedProduct.updatedAt,
          },
        },
      });
    }
  );
}

export default updateProduct;
