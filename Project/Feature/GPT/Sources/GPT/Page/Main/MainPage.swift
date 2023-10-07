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
  @Namespace private var lastMessage
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

      ScrollViewReader { proxy in
        ScrollView {
          Text(message)

          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .opacity(isLoading ? 1 : .zero)
            .id(lastMessage)
        }
        .onChange(of: message) { _, _ in
          proxy.scrollTo(lastMessage, anchor: .bottom)
        }
      }

      Spacer()
      switch isLoading {
      case true:
        HStack {
          Text("출력중.....")
          Button(action: { viewStore.send(.onTapCancel)}) {
            Text("중단")
          }
        }

      case false:
        HStack(alignment: .top) {
          TextField.init("", text: viewStore.$message, prompt: Text("Please input your comment"), axis: .vertical)
            .lineLimit(3)
            .border(Color.blue)
            .onSubmit {
              viewStore.send(.onTapSendMessage)
            }

          Button(action: { viewStore.send(.onTapSendMessage) }, label: {
            Text("전송")
          })
        }
        .disabled(isLoading)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .frame(minHeight: 50)


      }
    }
    .padding(.horizontal, 16)
    .ignoreNavigationBar()
  }
}
