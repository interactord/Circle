import Architecture
import Foundation
import LinkNavigator

struct Chapter1RouteBulder<RootNavigator: LinkNavigatorProtocol & LinkNavigatorFindLocationUsable> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.GPT.Path.chapter1.rawValue

    return .init(matchPath: matchPath) { _, _, dependency -> RouteViewController? in
      guard let env: GPTSideEffect = dependency.resolve() else { return .none }

      return WrappingController(matchPath: matchPath) {
        Chapter1Page(store: .init(
          initialState: Chapter1Store.State(),
          reducer: {
            Chapter1Store(env: Chapter1EnvLive(useCaseGroup: env))
          }))
      }
    }
  }
}
