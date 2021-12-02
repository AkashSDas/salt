import { Request, Response } from "express";
import BlogPost, { BlogPostDocument } from "../../models/blog-post";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";
import MongoPaging from "mongo-cursor-pagination";
import { MainUserDocument } from "../../models/main-user";

async function getAllBlogPostsOfSingleUser(req: Request, res: Response) {
  const next = req.query.next;

  const LIMIT = 1;
  const limit = req.query.limit ? parseInt(req.query.limit as string) : LIMIT;

  const profile = req.profile;

  const [data, err] = await runAsync(
    MongoPaging.find(BlogPost.collection, {
      query: { author: profile._id },
      paginatedField: "updatedAt",
      limit,
      next,
    })
  );

  if (err)
    return responseMsg(res, {
      status: 400,
      message: "Failed to retrive posts",
    });

  /// since traditional for loop is more performant then forEach and
  /// here we can have lots of data to loop, so tranditional for loop
  /// is used
  const posts = [];
  for (let i = 0; i < data.results.length; i++) {
    const [p, err] = await runAsync(
      BlogPost.populate(data.results[i], "author categories")
    );

    if (err)
      return responseMsg(res, {
        status: 400,
        message: "Failed to retrive posts",
      });

    const post: BlogPostDocument = p;

    let author: MainUserDocument = post.author;
    author.salt = undefined;
    author.encryptPassword = undefined;
    author.purchases = undefined;

    posts.push({
      _id: post._id,
      title: post.title,
      description: post.description,
      content: post.content,
      readTime: post.readTime,
      categories: post.categories,
      author: post.author,
      coverImgURL: post.coverImgURL,
      createdAt: post.createdAt,
      updatedAt: post.updatedAt,
    });
  }

  return responseMsg(res, {
    status: 200,
    error: false,
    message: `Retrived ${posts.length} posts successfully`,
    data: {
      posts,
      previous: data.previous,
      hasPrevious: data.hasPrevious,
      next: data.next,
      hasNext: data.hasNext,
    },
  });
}

export default getAllBlogPostsOfSingleUser;
