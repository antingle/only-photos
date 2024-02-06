import Logging
import Vapor

@main
enum Entrypoint {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)

        let app = Application(env)
        defer { app.shutdown() }

        do {
            try await configure(app)
        } catch {
            app.logger.report(error: error)
            throw error
        }
        
        if (env.arguments.contains { arg in arg == "migrate" }) {
            // do not run tailwind when doing migrations
            try await app.execute()
            return
        }

        switch app.environment {
        case .development:
            // Run the app and tailwind watching in parallel
            async let runApp: () = try await app.execute()
            _ = await [try runTailwindWatch(app), try await runApp]
        default:
            // Minify the CSS and run the app
            try await runTailwindMinify(app)
            try await app.execute()
        }

    }
}
