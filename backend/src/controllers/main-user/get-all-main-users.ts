import { Request, Response } from "express";
import MainUser, { MainUserDocument } from "../../models/main-user";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

async function getAllMainUsers(req: Request, res: Response) {
  /// if their is next id then use it to get data from that document
  /// if it is undefined then paginateUser will give documents from start
  const next = req.query.next;

  const LIMIT = 1;
  const limit = req.query.limit ? parseInt(req.query.limit as string) : LIMIT;

  const [data, err] = await runAsync(
    await (MainUser as any).paginateUser({
      limit,
      paginatedField: "updatedAt",
      next,
    })
  );

  /// since traditional for loop is more performant then forEach and
  /// here we can have lots of data to loop, so tranditional for loop
  /// is used
  const users = [];
  for (let i = 0; i < data.results.length; i++) {
    const user: MainUserDocument = data.results[i];
    users.push({
      _id: user._id,
      role: user.role,
      username: user.username,
      email: user.email,
      profilePicURL: user.profilePicURL,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      stripeCustomerId: user.stripeCustomerId,
    });
  }

  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Failed to retrive users",
    });

  return responseMsg(res, {
    status: 200,
    error: false,
    message: `Retrived ${users.length} users successfully`,
    data: {
      users,
      previous: data.previous,
      hasPrevious: data.hasPrevious,
      next: data.next,
      hasNext: data.hasNext,
    },
  });
}

export default getAllMainUsers;
