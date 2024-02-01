import Fluent
import FluentSQLiteDriver
import NIOSSL
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)
    app.migrations.add(CreatePost())

    // increase body size for image uploads
    app.routes.defaultMaxBodySize = "5mb"

    // register routes
    try routes(app)
}
