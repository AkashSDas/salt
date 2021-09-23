import { Request, Response } from "express";
import formidable, { File } from "formidable";
import { v4 } from "uuid";
import Product from "../../models/product";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";
import { bucket } from "../../firebase";

async function createProduct(req: Request, res: Response) {
  /// multiples: true to get multiple img files (in the form of array,
  /// coverImgs)
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

      const { title, description, quantity_left, price } = fields;
      const { coverImgs } = files;

      if (!title || !description || !quantity_left || !price || !coverImgs) {
        return responseMsg(res, {
          status: 400,
          message: "Please include all the fields",
        });
      }

      const data = { title, description, quantity_left, price };
      let product = new Product(data);

      const userId = req.profile._id;
      let imgURLs = [];
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
      const [savedProduct, e] = await runAsync(product.save());
      if (e)
        return responseMsg(res, {
          status: 400,
          message: "Could not save product",
        });

      return responseMsg(res, {
        status: 200,
        error: false,
        message: "Successfully saved product",
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

export default createProduct;
