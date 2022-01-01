import { readJsonSync } from "fs-extra";
import Downloader from "nodejs-file-downloader";
import path from "path";
import { runAsync } from "../utils";

const downloadUsersProfilePics = async () => {
  const json = readJsonSync(
    path.resolve(__dirname, "../../data/users/download.json")
  );
  const urls = json["downloadURLs"];

  for (let i = 0; i < urls.length; i++) {
    const downloader = new Downloader({
      url: urls[i],
      directory: "./data/users/images",
      maxAttempts: 10,
      onBeforeSave: (_) => {
        if (i < 10) return `00${i}.jpeg`;
        if (i >= 10 && i < 100) return `0${i}.jpeg`;
        return `${i}.jpeg`;
      },
    });
    console.log(await runAsync(downloader.download()));
  }
};

downloadUsersProfilePics();
