import LinkNavigator

public struct GPTRouteBuilderGroup<RootNavigator: LinkNavigatorProtocol & LinkNavigatorFindLocationUsable> {
  public static var release: [RouteBuilderOf<RootNavigator>] {
    [
      MainRouteBulder.generate(),
    ]
  }
}
