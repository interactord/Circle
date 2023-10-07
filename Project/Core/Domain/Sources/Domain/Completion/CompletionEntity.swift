import Foundation

public enum CompletionEntity {
  public struct Request: Codable, Equatable {
    public let model: String
    public let prompt: String
    public let temperature: Float?
    public let maxTokens: Int

    public init(model: String, prompt: String, temperature: Float?, maxTokens: Int) {
      self.model = model
      self.prompt = prompt
      self.temperature = temperature
      self.maxTokens = maxTokens
    }

    private enum CodingKeys: String, CodingKey {
      case model
      case prompt
      case temperature
      case maxTokens = "max_tokens"
    }
  }

  public struct Response: Codable, Equatable {

    public let id: String
    public let choiceList: [Choice]

    private enum CodingKeys: String, CodingKey {
      case id
      case choiceList = "choices"
    }

    public struct Choice: Codable, Equatable {
      public let text: String
    }
  }
}
