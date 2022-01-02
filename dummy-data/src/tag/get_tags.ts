import { fetchFromAPI } from "../utils";

export const getTags = async () => {
  const response = await fetchFromAPI("/tag", { method: "GET" });
  const tags = response[0].data.data.tags;
  console.log(tags);
  return tags;
};

getTags();
