import Foundation

struct ChallengePayloadTemplate: Encodable {
    let module: String = "authenticator"
    let action: Int = 0

    static func toJson() -> Data {
        return try! JSONEncoder().encode(ChallengePayloadTemplate())
    }
}

struct LoginTemplate: Encodable {
    let module: String = "authenticator"
    let action: Int = 1

    static func toJson() -> Data {
        return try! JSONEncoder().encode(LoginTemplate())
    }
}
