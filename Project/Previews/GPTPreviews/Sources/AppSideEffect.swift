import Architecture
import Domain
import GPT
import LinkNavigator
import Platform

// MARK: - AppSideEffect

struct AppSideEffect: DependencyType, GPTSideEffect {
  public let completionUseCase: CompletionUseCase
  public let streamUseCase: StreamUseCase
}

// MARK: MovieSideEffectGroup

extension AppSideEffect {
  static var live: Self {
    let configuration = ConfigurationRepository(
      apiURL: "https://api.openai.com",
      model: "gpt-3.5-turbo")
    return self.init(
      completionUseCase: CompletionUseCasePlatform(
        configurationRepository: configuration),
      streamUseCase: StreamUseCasePlatform(
        configurationRepository: configuration))
  }
}
