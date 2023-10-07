import Foundation

public struct StreamEntity {

}

extension StreamEntity {
  public struct Request: Codable, Equatable {
    public let model: String
    public let messageList: [Message]
    public let stream: Bool

    public init(model: String, messageList: [Message], stream: Bool) {
      self.model = model
      self.messageList = messageList
      self.stream = stream
    }

    private enum CodingKeys: String, CodingKey {
      case model
      case messageList = "messages"
      case stream
    }

    public struct Message: Codable, Equatable {
      public let role: String
      public let content: String

      public init(role: String, content: String) {
        self.role = role
        self.content = content
      }
    }
  }
}

extension StreamEntity {
  public struct Response: Codable, Equatable {
    public let id: String
    public let object: String
    public let created: Int
    public let model: String
    public let choiceList: [Choice]

    private enum CodingKeys: String, CodingKey {
      case id
      case object
      case created
      case model
      case choiceList = "choices"
    }

    public struct Choice: Codable, Equatable {
      public let delta: Delta
      public let finishReason: String?

      private enum CodingKeys: String, CodingKey {
        case delta
        case finishReason = "finish_reason"
      }
    }

    public struct Delta: Codable, Equatable {
      public let role: String?
      public let content: String?
    }

  }
}
