import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - Chapter1Page

struct Chapter1Page {

  init(store: StoreOf<Chapter1Store>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  let store: StoreOf<Chapter1Store>
  @ObservedObject private var viewStore: ViewStoreOf<Chapter1Store>
  @Namespace private var lastMessage
}

extension Chapter1Page {
  private var isLoading: Bool {
    viewStore.fetchMessage.isLoading
  }

  private var message: String {
    viewStore.fetchMessage.value
  }

  private var itemList: [(String, String)] {
    Array(zip(viewStore.questionList, viewStore.answerList))
  }
}

// MARK: View

extension Chapter1Page: View {
  var body: some View {
    VStack {
      Spacer()

      Text("GPT에게 말해봐요")

      ScrollViewReader { proxy in
        ScrollView {
          ForEach(itemList, id: \.0) { item in
            VStack(alignment: .leading, spacing: 12) {
              HStack {
                Spacer()

                Text(item.0) // 질문
                  .padding()
                  .background(
                    RoundedRectangle(cornerRadius: 20)
                      .fill(Color.blue.opacity(0.5)))
              }

              HStack {
                Text(item.1) // 대답
                  .padding()
                  .background(
                    RoundedRectangle(cornerRadius: 20)
                      .fill(Color.gray.opacity(0.5)))
                Spacer()
              }
            }
            .padding(.vertical, 8)
          }

          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .padding()
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
          Button(action: { viewStore.send(.onTapCancel) }) {
            Text("중단")
          }
        }
      case false:
        HStack(alignment: .bottom) {
          TextField("", text: viewStore.$message, prompt: Text("여기에 입력하세요"), axis: .vertical)
            .frame(minHeight: 40)
            .onSubmit {
              viewStore.send(.onTapSendMessage)
            }

          Button(action: { viewStore.send(.onTapSendMessage) }) {
            Text("전송")
              .frame(minHeight: 40)
          }
        }
        .disabled(isLoading)
        .padding(.horizontal, 16)
        .border(Color.blue)
        .frame(maxHeight: 100)
      }
    }
    .padding(.horizontal, 16)
    .ignoreNavigationBar()
  }
}
