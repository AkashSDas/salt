import { fetchFromAPI } from "../utils";
import { loginUser } from "./login";

export const getUsers = async () => {
  const admin = await loginUser("james@gmail.com");
  const users = await fetchFromAPI(`/user/${admin.user.id}`, {
    method: "GET",
    token: admin.token,
  });
  return users[0].data.data.users;
};
