import Architecture
import Foundation
import LinkNavigator

struct MainRouteBulder<RootNavigator: LinkNavigatorProtocol & LinkNavigatorFindLocationUsable> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.GPT.Path.main.rawValue

    return .init(matchPath: matchPath) { _, _, dependency -> RouteViewController? in
      guard let env: GPTSideEffect = dependency.resolve() else { return .none }

      return WrappingController(matchPath: matchPath) {
        MainPage(store: .init(
          initialState: MainStore.State(),
          reducer: {
            MainStore(env: MainEnvLive(useCaseGroup: env))
          }))
      }
    }
  }
}
