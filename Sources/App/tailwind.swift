import SwiftyTailwind
import TSCBasic
import Vapor

// TODO: Clean up this file to not duplicate code
// use for development
func runTailwindWatch(_ app: Application) async throws {
    let resourcesDirectory = try AbsolutePath(validating: app.directory.resourcesDirectory)
    let publicDirectory = try AbsolutePath(validating: app.directory.publicDirectory)
    let tailwind = SwiftyTailwind()
    
    async let runTailwind: () = tailwind.run(
        input: .init(validating: "Styles/app.css", relativeTo: resourcesDirectory),
        output: .init(validating: "styles/app.generated.css", relativeTo: publicDirectory),
        options: .watch, .content("\(app.directory.viewsDirectory)/**/*.leaf"))
    return try await runTailwind
}

// use for production
func runTailwindMinify(_ app: Application) async throws {
    let resourecesDirectory = try AbsolutePath(validating: app.directory.resourcesDirectory)
       let publicDirectory = try AbsolutePath(validating: app.directory.publicDirectory)
       let tailwind = SwiftyTailwind()
    
       try await tailwind.run(
           input: .init(validating: "Styles/app.css", relativeTo: resourecesDirectory),
           output: .init(validating: "styles/app.generated.css", relativeTo: publicDirectory),
           options: .minify, .content("\(app.directory.viewsDirectory)/**/*.leaf")
       )
}
