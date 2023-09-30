import ComposableArchitecture
import SwiftUI
import DesignSystem

struct MainPage {

  init(store: StoreOf<MainStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  let store: StoreOf<MainStore>
  @ObservedObject private var viewStore: ViewStoreOf<MainStore>
}

extension MainPage: View {
  var body: some View {
    VStack {
      Spacer()
      Text("Main Page")
      Spacer()
    }
    .ignoreNavigationBar()
  }
}
