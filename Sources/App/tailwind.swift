#if DEBUG
    // only used for hot reloading CSS in development
    import SwiftyTailwind
    import TSCBasic
    import Vapor

    func runTailwind(_ app: Application) async throws {
        let resourcesDirectory = try AbsolutePath(validating: app.directory.resourcesDirectory)
        let publicDirectory = try AbsolutePath(validating: app.directory.publicDirectory)
        let tailwind = SwiftyTailwind()

        async let runTailwind: () = tailwind.run(
            input: .init(validating: "Styles/app.css", relativeTo: resourcesDirectory),
            output: .init(validating: "styles/app.generated.css", relativeTo: publicDirectory),
            options: .watch, .content("\(app.directory.viewsDirectory)/**/*.leaf")
        )
        return try await runTailwind
    }
#endif
