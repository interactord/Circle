import Architecture
import Domain
import GPT
import LinkNavigator
import Platform

// MARK: - AppContainer

final class AppContainer {

  // MARK: Lifecycle

  init(
    dependency: AppSideEffect,
    navigator: SingleLinkNavigator)
  {
    self.dependency = dependency
    self.navigator = navigator
  }

  // MARK: Internal

  let dependency: AppSideEffect
  let navigator: SingleLinkNavigator
}

extension AppContainer {
  class func build() -> AppContainer {
    let dependency = AppSideEffect.live
    return .init(
      dependency: dependency,
      navigator: .init(
        routeBuilderItemList: GPTRouteBuilderGroup.release,
        dependency: dependency))
  }
}
