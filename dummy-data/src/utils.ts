import axios, { Method } from "axios";
import { config } from "dotenv";
import {
  ensureDirSync,
  pathExistsSync,
  readJsonSync,
  writeJsonSync,
} from "fs-extra";
import * as path from "path";

// Load env vars
config();

/**
 * @remarks
 * This will handle async functions to avoid repeating
 * try-catch blocks
 *
 * @returns [result, err]
 */
export async function runAsync(promise: Promise<any>): Promise<Array<any>> {
  try {
    const result = await promise;
    return [result, null];
  } catch (err) {
    return [null, err];
  }
}

/**
 * Get images from Unsplash
 */
export const getUnsplashDownloadURLs = async (
  query: string,
  orientation: "squarish" | "landscape" | "portrait" | "any",
  perPage: number,
  pageNum: number
) => {
  const [result, err] = await runAsync(
    axios.get(
      orientation == "any"
        ? `https://api.unsplash.com/search/photos?query=${query}&per_page=${perPage}&page=${pageNum}`
        : `https://api.unsplash.com/search/photos?query=${query}&orientation=${orientation}&per_page=${perPage}&page=${pageNum}`,
      {
        headers: {
          Authorization: `Client-ID ${process.env.UNSPLASH_ACCESS_KEY}`,
        },
      }
    )
  );

  if (err) {
    console.log(`Error while getting ${query} images\n${err}`);
    return [];
  }

  const imgs = result.data.results;
  console.log(`Retrieved ${imgs.length} images for query ${query}`);
  let urls = [];
  for (let i = 0; i < imgs.length; i++) {
    urls.push(imgs[i].links.download);
  }
  return urls;
};

/**
 * Save list of Unsplash download urls
 */
export const upsertUnsplashDownloadURLs = (
  urls: string[],
  location: string
) => {
  location = path.resolve(__dirname, location); // path to current working dir + location
  ensureDirSync(location);
  const jsonLocation = `${location}/download.json`;
  if (pathExistsSync(jsonLocation)) {
    const data = readJsonSync(`${location}/download.json`);
    urls = [...data["downloadURLs"], ...urls];
  }
  writeJsonSync(`${location}/download.json`, { downloadURLs: urls });
};

export const axiosBaseInstance = () => {
  return axios.create({ baseURL: process.env.BACKEND_URL });
};

export const fetchFromAPI = async (
  endpointURL: string,
  opts: {
    method: Method;
    data?: any;
    token?: string;
  }
) => {
  const api = axiosBaseInstance();
  const { method, data, token } = { ...opts };

  return await runAsync(
    api(endpointURL, {
      method,
      data,
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
    })
  );
};
