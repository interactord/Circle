import Architecture
import LinkNavigator
import SwiftUI
import Platform

@main
struct AppMain: App {

  @StateObject var viewModel = AppMainViewModel()

  var body: some Scene {
    WindowGroup {
      LinkNavigationView(
        linkNavigator: viewModel.linkNavigator,
        item: .init(path: Link.GPT.Path.main.rawValue, items: ""))
        .ignoresSafeArea()
    }
  }
}
