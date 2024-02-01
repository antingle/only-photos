import Fluent
import Vapor

struct PostController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let posts = routes.grouped("posts")
    posts.get(use: index)
    posts.post(use: create)
    posts.group(":postID") { post in
      post.delete(use: delete)
    }
  }

  func index(req: Request) async throws -> [PostResponse] {
    let posts = try await Post.query(on: req.db).all()
    var postResponses: [PostResponse] = []
    for post in posts {
      req.logger.info("\(post.id?.uuidString ?? "NO ID")")
      guard
        let imageLink = URL(
          string:
            "http://\(req.application.http.server.configuration.hostname):\(req.application.http.server.configuration.port)/\(post.fileName)"
        )
      else {
        throw Abort(.internalServerError)
      }
      postResponses.append(
        PostResponse(id: post.id!, description: post.description, imageLink: imageLink))
    }
    return postResponses
  }

  func create(req: Request) async throws -> HTTPStatus {
    let postContent = try req.content.decode(PostContent.self)
    let fileName = postContent.image.filename
    try await req.fileio.writeFile(
      postContent.image.data, at: req.application.directory.publicDirectory + fileName)

    let post = Post(description: postContent.description, fileName: fileName)
    try await post.save(on: req.db)
    return .created
  }

  func delete(req: Request) async throws -> HTTPStatus {
    guard let post = try await Post.find(req.parameters.get("postID"), on: req.db) else {
      throw Abort(.notFound)
    }
    try FileManager().removeItem(atPath: req.application.directory.publicDirectory + post.fileName)
    try await post.delete(on: req.db)
    return .noContent
  }
}