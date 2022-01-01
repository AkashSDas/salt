import { readdirSync, readFileSync, readJsonSync } from "fs-extra";
import path from "path";
import * as faker from "faker";
import { getUsers } from "../user/get_users";
import { loginUser } from "../user/login";
import { getTags } from "../tag/get_tags";
import { fetchFromAPI } from "../utils";

const createProducts = async () => {
  const productFiles = readdirSync(
    path.resolve(__dirname, "../../data/products")
  );

  // Get sellers
  const users = await getUsers();
  const sellers = [];
  for (let i = 0; i < users.length; i++) {
    if (users[i].roles.filter((r) => r === "seller").length > 0) {
      sellers.push(users[i]);
    }
  }

  // Get tags
  const tags = await getTags();

  for (let i = 0; i < productFiles.length; i++) {
    // Get seller info
    const sellerIdx = faker.datatype.number(sellers.length - 1);
    const user = sellers[sellerIdx];
    const { token } = await loginUser(user.email);

    const json = readJsonSync(
      path.resolve(
        __dirname,
        `../../data/products/${productFiles[i]}/download.json`
      )
    );
    const urls = json["downloadURLs"];

    for (let j = 0; j < 60; j++) {
      let coverImgURLs = [];

      // Get imgs randomly
      for (let k = 0; k < 6; k++) {
        let urlIdx = faker.datatype.number(urls.length - 1);
        coverImgURLs.push(urls[urlIdx]);
      }

      let tagCount = 0;
      const numOfTags = faker.datatype.number(6);
      // Get tags
      let tagsData = [];
      tags.map((t) => {
        if (t.name === productFiles[i]) {
          tagsData.push(t.id);
        } else {
          if (numOfTags !== tagCount) {
            if (faker.datatype.number(1)) {
              tagsData.push(t.id);
              tagCount++;
            }
          }
        }
      });

      const data = {
        title: faker.lorem.sentence(10),
        description: faker.lorem.sentence(20),
        info: readFileSync(
          path.resolve(__dirname, "../../data/dummy-markdown.md")
        ).toString(),
        price: faker.datatype.number(1000),
        coverImgURLs,
        userId: user.id,
        tags: JSON.stringify(tagsData),
      };

      let response = await fetchFromAPI(`/product/admin/${user.id}`, {
        data,
        method: "POST",
        token,
      });
      console.log(response[0].data.msg);
    }
  }
};

createProducts();
