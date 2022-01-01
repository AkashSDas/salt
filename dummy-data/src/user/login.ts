import { fetchFromAPI } from "../utils";

export const loginUser = async (email: string) => {
  const resposne = await fetchFromAPI("/auth/login", {
    method: "POST",
    data: { email, password: "testing" },
  });
  return resposne[0].data.data;
};
