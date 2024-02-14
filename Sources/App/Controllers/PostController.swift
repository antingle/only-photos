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
        let posts = try await Post.query(on: req.db).all().reversed()
        var postResponses: [PostResponse] = []
        for post in posts {
            req.logger.info("\(post.id?.uuidString ?? "NO ID")")
            guard
                let imageLink = URL(
                    string:
                    "http://\(req.application.http.server.configuration.hostname):\(req.application.http.server.configuration.port)/\(post.imagePath)"
                )
            else {
                throw Abort(.internalServerError)
            }
            postResponses.append(
                PostResponse(id: post.id!, description: post.description, imageLink: imageLink))
        }
        return postResponses
    }

    func create(req: Request) async throws -> Response {
        let postContent = try req.content.decode(PostContent.self)
        let fileName = postContent.image.filename
        guard let imageURLPath = URL(string: "images/" + fileName) else { throw Abort(.badRequest) } // convert to URL to manipulate file name
        guard let imagePath = imageURLPath.addingTimestamp().absoluteString.removingPercentEncoding else { throw Abort(.internalServerError) }

        try await req.fileio.writeFile(postContent.image.data,
                                       at: req.application.directory.publicDirectory.finished(with: "/" + imagePath))

        let post = Post(description: postContent.description, imagePath: imagePath)
        try await post.save(on: req.db)
        return req.redirect(to: "/")
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let post = try await Post.find(req.parameters.get("postID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try FileManager().removeItem(
            atPath: req.application.directory.publicDirectory.finished(with: "/" + post.imagePath))
        try await post.delete(on: req.db)
        return .noContent
    }
}
