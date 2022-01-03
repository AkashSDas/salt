import { readdirSync, readFileSync, readJsonSync } from "fs-extra";
import path from "path";
import * as faker from "faker";
import { getUsers } from "../user/get_users";
import { loginUser } from "../user/login";
import { getTags } from "../tag/get_tags";
import { fetchFromAPI } from "../utils";
import { postDescriptionMap, postTitleMap } from "./data";

const createPosts = async () => {
  const productFiles = readdirSync(
    path.resolve(__dirname, "../../data/unsplash_small_urls/products")
  );

  // Get sellers
  const users = await getUsers();

  // Get tags
  const tags = await getTags();

  for (let i = 0; i < productFiles.length; i++) {
    const json = readJsonSync(
      path.resolve(
        __dirname,
        `../../data/unsplash_small_urls/products/${productFiles[i]}/download.json`
      )
    );
    const urls = json["downloadURLs"];

    for (let j = 0; j < postTitleMap[productFiles[i]].length; j++) {
      // Get seller info
      const userIdx = faker.datatype.number(users.length - 1);
      const user = users[userIdx];
      const { token } = await loginUser(user.email);

      // Get imgs randomly
      let urlIdx = faker.datatype.number(urls.length - 1);
      const coverImgURL = urls[urlIdx];

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
        // title: faker.lorem.sentence(10),
        // description: faker.lorem.sentence(20),
        title: postTitleMap[productFiles[i]][j],
        description: postDescriptionMap[productFiles[i]][j],
        content: readFileSync(
          path.resolve(
            __dirname,
            `../../data/markdown/${productFiles[i]}/0${j + 1}.md`
          )
        ).toString(),
        published: faker.datatype.boolean(),
        coverImgURL,
        userId: user.id,
        tags: JSON.stringify(tagsData),
      };

      let response = await fetchFromAPI(`/post/admin/${user.id}`, {
        data,
        method: "POST",
        token,
      });
      console.log(response[0].data.msg);
    }
  }
};

createPosts();
