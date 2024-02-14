import Fluent
import Foundation

struct CreatePost: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("posts")
            .id()
            .field("description", .string, .required)
            .field("image_path", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("posts").delete()

        // remove images stored in Public/images/
        let fileManager = FileManager.default
        let imagesPath = fileManager.currentDirectoryPath.finished(with: "/Public/images/")
        let images = try fileManager.contentsOfDirectory(atPath: imagesPath)
        for image in images {
            try fileManager.removeItem(atPath: imagesPath + image)
        }
    }
}
