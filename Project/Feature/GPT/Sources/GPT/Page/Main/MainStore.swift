import Architecture
import ComposableArchitecture
import Foundation
import Domain

struct MainStore {

  let env: MainEnvType
  private let pageID = UUID().uuidString
}

extension MainStore: Reducer {

  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .merge(
          CancelID.allCases.map{ .cancel(pageID: pageID, id: $0)
          })

      case .sendMessage:
        state.fetchMessage.isLoading = true
        return env.sendMessage(state.message)
          .cancellable(pageID: pageID, id: CancelID.requestSendMessage, cancelInFlight: true)

      case .fetchMessage(let result):
        switch result {
        case .success(let message):
          state.fetchMessage.isLoading = !message.isFinish
          state.fetchMessage.value = state.fetchMessage.value.merge(rawValue: message)

          switch message.isFinish {
          case true:
            state.message = ""

          case false:
            break

          }
          return .none

        case .failure(let error):
          state.fetchMessage.isLoading = false
          return .run { await $0(.throwError(error)) }
        }

      case .throwError(let error):
        print(error)
        return .none
      }
    }
  }

}

extension MainStore {
  struct State: Equatable {
    init() {
      _fetchMessage = .init(.init(isLoading: false, value: .init()))
    }

    @BindingState var message = ""
    @Heap var fetchMessage: FetchState.Data<MessageScope>
  }

  struct MessageScope: Equatable {
    let content: String
    let isFinish: Bool

    init(content: String = "", isFinish: Bool = true) {
      self.content = content
      self.isFinish = isFinish
    }
  }

}

extension MainStore {
  enum Action: BindableAction, Equatable {
    case teardown
    case binding(BindingAction<State>)

    case sendMessage
    case fetchMessage(Result<MessageScope, CompositeErrorDomain>)
    case throwError(CompositeErrorDomain)
  }
}

extension MainStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestSendMessage
  }
}


extension MainStore.MessageScope {
  func merge(rawValue: Self) -> Self {
    .init(
      content: content + rawValue.content,
      isFinish: rawValue.isFinish)
  }
}
