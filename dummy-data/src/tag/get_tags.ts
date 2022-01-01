import { fetchFromAPI } from "../utils";

export const getTags = async () => {
  const response = await fetchFromAPI("/tag", { method: "GET" });
  return response[0].data.data.tags;
};
