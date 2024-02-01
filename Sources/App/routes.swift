import Fluent
import Vapor

func routes(_ app: Application) throws {

    app.get { req async throws -> View in
        let posts = try await Post.query(on: req.db).all()
        return try await req.view.render("index", ["posts": posts])
    }

    try app.register(collection: PostController())
}
