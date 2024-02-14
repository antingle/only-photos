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

        #if DEBUG
            if (env.arguments.contains { arg in arg == "migrate" }) {
                try await app.execute()
            } else {
                async let runApp: () = try await app.execute()
                _ = try await [runTailwind(app), await runApp]
            }
        #else
            try await app.execute()
        #endif
    }
}
