import Foundation
import Logging

public struct M7200Client: Sendable {
    private let endpoint: URL
    private let password: String
    private let username: String
    private let logger: Logger
    private let session: URLSession

    private var sequenceNumber: Int? = nil
    private var rsaMod: Int? = nil
    private var rsaPublicKey: String = "010001"
    private var aesKey: Data? = nil
    private var aesIV: Data? = nil
    private var token: String? = nil

    private let defaultHeaders: [String: String]

    public init(
        endpoint: URL,
        username: String,
        password: String,
        logger: Logger,
        session: URLSession
    ) {
        self.endpoint = endpoint
        self.username = username
        self.password = password
        self.logger = logger
        self.session = session

        self.defaultHeaders = [
            "Content-Type": "application/json",
            "Referer": self.endpoint.absoluteString,
        ]
    }

    private func postJSON(path: String, body: [String: some Encodable]) async throws -> Data? {
        let url = self.endpoint.appending(path: path)
        guard let data = try? JSONEncoder().encode(body) else {
            throw InvalidBodyError()
        }
        self.logger.debug("POST \(url) body=\(data)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.allHTTPHeaderFields = self.defaultHeaders

        guard let (responseData, response) = try? await URLSession.shared.data(for: request) else {
            logger.error("Error with request to \(url) with body \(data)")
            return nil
        }

        guard let httpResponse = (response as? HTTPURLResponse) else {
            throw NetworkingError.invalidStatusCode(statusCode: -1)
        }

        self.logger.debug("Response \(httpResponse.statusCode) body=\(responseData)")

        return responseData
    }

    private func fetchChallenge() async throws -> Challenge? {
        let payload = [
            "data": ChallengePayloadTemplate.toJson()
        ]

        guard
            let challengeResponseDataBase64 = try? await self.postJSON(
                path: "/cgi-bin/auth_cgi", body: payload)
        else {
            self.logger.error("Error with postJSON")
            return nil
        }

        guard
            let challengeResponseData = Data(base64Encoded: challengeResponseDataBase64)
        else {
            self.logger.error(
                "Error decoding base64 data \(String(data: challengeResponseDataBase64, encoding: .ascii) ?? "<Unable to decode challengeResponseDataBase64 as ascii>")"
            )
            return nil
        }

        guard
            let challengeResponse = try? JSONDecoder().decode(
                Challenge.self, from: challengeResponseData)
        else {
            self.logger.error(
                "Error decoding \(String(data: challengeResponseData, encoding: .ascii) ?? "<Unable to decode challengeResponseData as ascii") to Challenge type"
            )
            return nil
        }

        return challengeResponse
    }

    private func buildLoginPayload(challenge: Challenge) {
        let nonce = challenge.nonce
    }

    public func login() async throws -> Challenge? {
        guard let challenge = try? await self.fetchChallenge() else {
            print("Unable to fetch challenge")
            return nil
        }
        guard let challengeString = try? JSONEncoder().encode(challenge) else {
            print("Unable to decode \"\(challenge)\" into a String")
            return nil
        }

        self.logger.debug("\(challengeString)")
        return challenge
    }
}
