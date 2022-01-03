import { loginUser } from "../user/login";
import { getUsers } from "../user/get_users";
import { fetchFromAPI } from "../utils";

export const createFeedback = async () => {
  const users = await getUsers();
  let userId;
  users.map((u) => {
    if (u.email === "james@gmail.com") {
      userId = u.id;
    }
  });

  console.log(userId);
  const { token } = await loginUser("james@gmail.com");
  await fetchFromAPI(`/feedback/user/${userId}`, { method: "GET", token });
  console.log("DONE");
};

createFeedback();
