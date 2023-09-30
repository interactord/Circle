import Architecture
import Domain
import LinkNavigator
import GPT
import Platform

// MARK: - AppSideEffect

struct AppSideEffect: DependencyType, GPTSideEffect {
  public let completionUseCase: CompletionUseCase
}

// MARK: MovieSideEffectGroup

extension AppSideEffect { 
  static var live: Self {
    let configuration = ConfigurationRepository(
      apiURL: "https://api.openai.com",
      model: "gpt-3.5-turbo-instruct")
    return self.init(completionUseCase: CompletionUseCasePlatform(
      configurationRepository: configuration))
  }
}
