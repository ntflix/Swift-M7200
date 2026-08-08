import Foundation

public struct Challenge: Codable {
  let authedIP: String
  let nonce: String
  let rsaPubKey: String
  let rsaMod: String
  let seqNum: Int
  let result: Int
}

struct ChallengeRequestPayload: Codable {
  let data: String
}
