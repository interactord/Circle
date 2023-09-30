import Architecture
import Domain
import LinkNavigator
import GPT

// MARK: - AppSideEffect

struct AppSideEffect: DependencyType, GPTSideEffect {
  init() { }
}

// MARK: MovieSideEffectGroup

extension AppSideEffect { }
