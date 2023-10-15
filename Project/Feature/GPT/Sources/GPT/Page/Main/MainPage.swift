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

  private var chatList: [MainStore.MessageScope] {
//    print(viewStore.chatList)
    return viewStore.chatList
  }
}

// MARK: View

extension MainPage: View {
  var body: some View {
    VStack {
      Spacer()
      
      Text("GPT에게 말해봐요")
      
//      ScrollViewReader { proxy in
        ScrollView {
          LazyVStack {
            ForEach(chatList, id: \.id) { item in
              ChatItemComponent(viewState: .init(item: item))
            }
          }
        }
//        .onChange(of: message) { _, _ in
//          proxy.scrollTo(lastMessage, anchor: .bottom)
//        }
//      }
      
      Spacer()

      HStack(alignment: .top, spacing: 8) {
        Group {
          TextField("", text: viewStore.$message, prompt: Text("여기에 입력하세요"), axis: .vertical)
            .frame(minHeight: 50)
            .lineLimit(3...5)
            .onSubmit {
              viewStore.send(.onTapSendMessage)
            }
        }
        .padding(16)
        .border(.blue, width: 1)

        Button(action: { viewStore.send(.onTapSendMessage) }) {
          Text("전송")
            .padding(8)

        }
        .padding(8)
        .border(.blue, width: 1)

      }
      .disabled(isLoading)
      .frame(maxHeight: 120)
//      switch isLoading {
//      case true:
//        HStack {
//          Text("출력중.....")
//          Button(action: { viewStore.send(.onTapCancel)}) {
//            Text("중단")
//          }
//        }
//        
//      case false:
//
//        
//      }
    }
    .padding(.horizontal, 16)
    .ignoreNavigationBar()
  }
}


extension MainPage {
  struct ChatItemComponent { 
    let viewState: ViewState
  }
}

extension MainPage.ChatItemComponent: View {
  var body: some View {
    VStack {
      switch viewState.item.role {
      case .user:
        HStack {
          Spacer()
          Text(viewState.item.content)
          Text("🧑")
        }

      case .ai:
        HStack {
          Text("🤖 \(viewState.item.content)")
          Spacer()
        }
        if !viewState.item.isFinish {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .tint(.red)
        }
      }
    }
    .frame(maxWidth: .infinity)
  }
}

extension MainPage.ChatItemComponent {
  struct ViewState: Equatable {
    let item: MainStore.MessageScope
  }
}
