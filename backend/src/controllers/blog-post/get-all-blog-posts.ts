import { Request, Response } from "express";
import BlogPost, { BlogPostDocument } from "../../models/blog-post";
import { runAsync } from "../../utils";
import { responseMsg } from "../json-response";

async function getAllBlogPosts(req: Request, res: Response) {
  /// if their is next id then use it to get data from that document
  /// if it is undefined then paginateUser will give documents from start
  const next = req.query.next;

  const LIMIT = 1;
  const limit = req.query.limit ? parseInt(req.query.limit as string) : LIMIT;

  const [data, err] = await runAsync(
    await (BlogPost as any).paginateBlogPost({
      limit,
      paginatedField: "updatedAt",
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

    posts.push({
      _id: post._id,
      title: post.title,
      description: post.description,
      content: post.content,
      readTime: post.readTime,
      categories: post.categories,
      author: post.author,
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

export default getAllBlogPosts;
