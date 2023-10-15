import Combine
import Domain

// MARK: - CompletionUseCasePlatform

public struct CompletionUseCasePlatform {
  private let configurationRepository: ConfigurationRepository

  public init(configurationRepository: ConfigurationRepository) {
    self.configurationRepository = configurationRepository
  }
}

// MARK: CompletionUseCase

extension CompletionUseCasePlatform: CompletionUseCase {
  public var sendMessage: (String) -> AnyPublisher<CompletionEntity.Response, CompositeErrorDomain> {
    { message in  // 내가 하는 질문?
      let requestModel = CompletionEntity.Request(
        model: "gpt-3.5-turbo",
        messageList: [
          .init(role: "system", content: "You are a helpful assistant. "),
          .init(role: "user", content: message),
        ])
      print("AAA", requestModel.messageList)

      return Endpoint(
        baseURL: configurationRepository.apiURL,
        pathList: ["v1", "chat", "completions"],
        httpMethod: .post,
        content: .bodyItem(requestModel),
        header: ["Authorization": "Bearer \(token)"])
        .fetch()
    }
  }
}
