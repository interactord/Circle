import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - MainPage

struct MainPage {

  init(store: StoreOf<MainStore>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  let store: StoreOf<MainStore>
  @ObservedObject private var viewStore: ViewStoreOf<MainStore>
}

extension MainPage {
  private var isLoading: Bool {
    viewStore.fetchMessage.isLoading
  }

  private var message: String {
    viewStore.fetchMessage.value.content
  }
}

// MARK: View

extension MainPage: View {
  var body: some View {
    VStack {
      Spacer()

      Text("GPT에게 말해봐요")

      ScrollView {
        Text(message)

        if isLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
        }
      }

      Spacer()
      switch isLoading {
      case true:
        Text("출력중.....")

      case false:
        HStack {
          TextField("여기서 입력하세요", text: viewStore.$message)
            .frame(maxWidth: .infinity)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .disabled(isLoading)
            .onSubmit {
              viewStore.send(.sendMessage)
            }

          Button(action: { viewStore.send(.sendMessage) }, label: {
            Text("전송")
          })
        }
        .disabled(isLoading)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
      }
    }
    .padding(.horizontal, 16)
    .ignoreNavigationBar()
  }
}
