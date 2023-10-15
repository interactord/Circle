import Foundation

// MARK: - StreamEntity

public struct CompletionEntity { }

// MARK: StreamEntity.Request

extension CompletionEntity {
  public struct Request: Codable, Equatable {
    public let model: String
    public let messageList: [Message]
    
    // MARK: Lifecycle
    
    public init(model: String, messageList: [Message]) {
      self.model = model
      self.messageList = messageList
    }
    
    // MARK: Private
    
    private enum CodingKeys: String, CodingKey {
      case model
      case messageList = "messages"
    }
    
    // MARK: Public
    
    public struct Message: Codable, Equatable {
      public let role: String
      public let content: String  // 내가 질문한 것
      
      public init(role: String, content: String) {
        self.role = role
        self.content = content
      }
    }
  }
}

// MARK: StreamEntity.Response

extension CompletionEntity {
  public struct Response: Codable, Equatable {
    
    // MARK: Public
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
      public let message: Message
      public let finishReason: String
      
      private enum CodingKeys: String, CodingKey {
        case message
        case finishReason = "finish_reason"
      }
    }
    
    public struct Message: Codable, Equatable {
      public let role: String
      public let content: String
    }
  }
}
