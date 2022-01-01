import { getUnsplashDownloadURLs, upsertUnsplashDownloadURLs } from "../utils";

const getProfilePicURLs = async () => {
  // Get profile pics (120 imgs)
  const urls1 = await getUnsplashDownloadURLs("face", "squarish", 30, 1);
  const urls2 = await getUnsplashDownloadURLs("face", "squarish", 30, 2);
  const urls3 = await getUnsplashDownloadURLs("face", "squarish", 30, 3);
  const urls4 = await getUnsplashDownloadURLs("face", "squarish", 30, 4);
  const urls = [...urls1, ...urls2, ...urls3, ...urls4];
  upsertUnsplashDownloadURLs(urls, "../data/users");
};

getProfilePicURLs();
