import Architecture
import Domain
import LinkNavigator
import Platform
import GPT

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
//    let configuration = Self.configurationLive
    let dependency = AppSideEffect()
    return .init(
      dependency: dependency,
      navigator: .init(
        routeBuilderItemList: GPTRouteBuilderGroup.release,
        dependency: dependency))
  }
}

//extension AppContainer {
//  private class var configurationLive: ConfigurationDomain {
//    .init(
//      entity: .init(
//        baseURL: .init(
//          apiURL: "https://api.themoviedb.org/3",
//          apiToken: "1d9b898a212ea52e283351e521e17871",
//          imageURL: "https://image.tmdb.org/t/p/")))
//  }
//}
