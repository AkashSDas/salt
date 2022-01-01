import { fetchFromAPI } from "../utils";

export const loginUser = async (email: string) => {
  const response = await fetchFromAPI("/auth/login", {
    method: "POST",
    data: { email, password: "testing" },
  });
  return response[0].data.data;
};
