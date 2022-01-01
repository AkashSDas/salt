import { getUnsplashDownloadURLs, upsertUnsplashDownloadURLs } from "../utils";

const getProductPicURLs = async (query: string, category: string) => {
  const urls1 = await getUnsplashDownloadURLs(query, "any", 30, 1);
  const urls = [...urls1];
  upsertUnsplashDownloadURLs(urls, `../data/products/${category}`);
};

getProductPicURLs("sweets", "sweets");
