import ComposableArchitecture
import SwiftUI

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
    Text("Main Page")
  }
}
