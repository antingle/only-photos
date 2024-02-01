import Fluent

struct CreatePost: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("posts")
            .id()
            .field("description", .string, .required)
            .field("file_name", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("posts").delete()
    }
}
