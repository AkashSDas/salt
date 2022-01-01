import * as faker from "faker";
import { readJsonSync } from "fs-extra";
import path from "path";
import { fetchFromAPI } from "../utils";

// Note: profilePicURL field should not directly be added to user,
// instead a img file should be uploaded in the backend which will save the img
// and then the url of that saved img is going to be used to profilePicURL
// But for the ease of saving user data, directly adding profilePicURL

interface IUser {
  email: string;
  username: string;
  dateOfBirth: string;
  password: string;
  profilePicURL: string;
}

const createData = async () => {
  let data: IUser[] = [];
  const password = "testing"; // same password for every user

  // Get profile pics
  const json = readJsonSync(
    path.resolve(__dirname, "../../data/users/download.json")
  );
  const urls = json["downloadURLs"];

  for (let i = 0; i < 120; i++) {
    const date = faker.date.past(3);
    const gender = faker.datatype.number(1);
    const firstName = faker.name.firstName(gender);
    const lastName = faker.name.lastName(gender);

    data.push({
      email: `${faker.internet.email(firstName, lastName)}`,
      username: `${firstName} ${lastName}`,
      dateOfBirth: date.toISOString().split("T")[0],
      password,
      profilePicURL: urls[i],
    });
  }

  console.log(`Created 120 fake data`);

  // Save this data using back-end
  for (let i = 0; i < data.length; i++) {
    const [result, err] = await fetchFromAPI("/auth/signup", {
      method: "POST",
      data: data[i],
    });

    if (err?.response?.data?.error) {
      console.log(`Error saving ${i + 1}th user: ${err.response.data.msg}`);
      console.log(data[i]);
    } else if (result.data["error"]) {
      console.log(`Error saving ${i + 1}th user: ${result.data["msg"]}`);
      console.log(data[i]);
    } else console.log(`Saved ${i + 1}th user`);
  }
};

createData();
