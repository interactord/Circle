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
    { message in
      let requestModel = CompletionEntity.Request(
        model: configurationRepository.model,
        prompt: message,
        temperature: .zero,
        maxTokens: 2_048)

      return Endpoint(
        baseURL: configurationRepository.apiURL,
        pathList: ["v1", "completions"],
        httpMethod: .post,
        content: .bodyItem(requestModel),
        header: ["Authorization": "Bearer \(token)"])
        .fetch()
    }
  }
}
