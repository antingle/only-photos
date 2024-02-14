import Fluent
import Vapor

func routes(_ app: Application) throws {
    // index route
    app.get { req async throws -> View in
        let posts = try await Post.query(on: req.db).all().reversed()
        return try await req.view.render("index", ["posts": posts])
    }

    try app.register(collection: PostController())
}
