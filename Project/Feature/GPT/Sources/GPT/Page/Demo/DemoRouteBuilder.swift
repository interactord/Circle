import Architecture
import Foundation
import LinkNavigator

struct DemoRouteBuilder<RootNavigator: LinkNavigatorProtocol & LinkNavigatorFindLocationUsable> {
  static func generate() -> RouteBuilderOf<RootNavigator> {
    let matchPath = Link.GPT.Path.demo.rawValue

    return .init(matchPath: matchPath) { _, _, dependency -> RouteViewController? in
      guard let env: GPTSideEffect = dependency.resolve() else { return .none }

      return WrappingController(matchPath: matchPath) {
        DemoPage()
      }
    }
  }
}
