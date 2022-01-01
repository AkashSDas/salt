import faker from "faker";
import { fetchFromAPI } from "../utils";
import { getUsers } from "./get_users";
import { loginUser } from "./login";

export const becomeAdmin = async (userId: string, email: string) => {
  const { token } = await loginUser(email);
  const response = await fetchFromAPI(`/user/${userId}/roles/admin`, {
    method: "POST",
    token,
  });
  return response[0].data.msg;
};

export const becomeSeller = async (userId: string, email: string) => {
  const { token } = await loginUser(email);
  const streetAddress = faker.address.streetAddress(true);
  const firstName = faker.name.firstName();
  const suffix = faker.address.citySuffix();
  const zip = faker.address.zipCode("#####");
  const data = {
    bio: faker.lorem.sentences(),
    phoneNumber: faker.phone.phoneNumber("9#########"),
    address: `${streetAddress}, ${firstName} ${suffix}, ${zip}`,
  };

  const response = await fetchFromAPI(`/user/${userId}/roles/seller`, {
    method: "POST",
    data,
    token,
  });
  return response[0].data.msg;
};

const addRandomRoles = async () => {
  let adminCount = 0; // make 10 admins
  let sellerCount = 0; // make 30 admins

  const users = await getUsers();

  // Make admin
  for (let i = 0; i < users.length; i++) {
    const convert = faker.datatype.number(1);
    if (convert == 1 && adminCount < 10) {
      const response = await becomeAdmin(users[i].id, users[i].email);
      console.log(response);
      adminCount++;
    }
  }

  //   Make seller
  for (let i = 0; i < users.length; i++) {
    const convert = faker.datatype.number(1);
    if (convert == 1 && sellerCount < 30) {
      const response = await becomeSeller(users[i].id, users[i].email);
      console.log(response);
      sellerCount++;
    }
  }

  console.log("DONE");
};

addRandomRoles();
