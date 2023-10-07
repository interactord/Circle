import Domain
import Combine

public struct StreamUseCasePlatform {
  private let configurationRepository: ConfigurationRepository

  public init(configurationRepository: ConfigurationRepository) {
    self.configurationRepository = configurationRepository
  }
}

extension StreamUseCasePlatform: StreamUseCase {
  public var sendMessage: (String) -> AnyPublisher<StreamEntity.Response, CompositeErrorDomain> {
    { message in
      let requestModel = StreamEntity.Request(
        model: "gpt-3.5-turbo",
        messageList: [
          .init(role: "user", content: message)
        ],
        stream: true)

      return Endpoint(
        baseURL: configurationRepository.apiURL,
        pathList: ["v1", "chat", "completions"],
        httpMethod: .post,
        content: .bodyItem(requestModel),
        header: ["Authorization": "Bearer \(token)"])
      .sse()
    }
  }
}
