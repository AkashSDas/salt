import { getUnsplashDownloadURLs, upsertUnsplashDownloadURLs } from "../utils";

const getProductPicURLs = async (query: string, category: string) => {
  const urls1 = await getUnsplashDownloadURLs(query, "any", 30, 1);
  const urls = [...urls1];
  upsertUnsplashDownloadURLs(
    urls,
    `../data/unsplash_thumb_urls/products/${category}`
  );
};

// getProductPicURLs("breakfast", "breakfast");
const getAllImgs = async () => {
  await getProductPicURLs("cake", "cake");
  await getProductPicURLs("chocolate", "chocolate");
  await getProductPicURLs("coffee", "coffee");
  await getProductPicURLs("dairy", "dairy");
  await getProductPicURLs("drinks", "drinks");
  await getProductPicURLs("fast food", "fast-food");
  await getProductPicURLs("vegetables", "green-veggies");
  await getProductPicURLs("high protein food", "high-protein-food");
  await getProductPicURLs("ice cream", "ice-cream");
  await getProductPicURLs("lunch", "lunch");
  await getProductPicURLs("movie snack", "movie-snack");
  await getProductPicURLs("non veg food", "non-veg");
  await getProductPicURLs("salad", "salad");
  await getProductPicURLs("snacks", "snack");
  await getProductPicURLs("sushi", "sushi");
  await getProductPicURLs("sweets", "sweets");
};

getAllImgs();
