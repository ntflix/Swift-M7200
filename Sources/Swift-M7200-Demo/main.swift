import Foundation
import Logging
import Swift_M7200

@main
struct App {
    static func main() async {
        var logger = Logger(label: "m7200client")
        logger.logLevel = .trace

        let session = URLSession(configuration: .default)

        let endpoint = URL(string: "http://172.16.0.1")!

        let m7200client = M7200Client(
            endpoint: endpoint,
            username: "admin",
            password: "",
            logger: logger,
            session: session,
        )

        print("Started")
        let challenge = try? await m7200client.login()
        print(challenge)
    }
}
