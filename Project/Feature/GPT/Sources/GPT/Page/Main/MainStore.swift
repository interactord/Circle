import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - MainStore

struct MainStore {

  let env: MainEnvType
  private let pageID = UUID().uuidString
}

// MARK: Reducer

extension MainStore: Reducer {

  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .merge(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })

      case .sendMessage:
        state.fetchMessage.isLoading = true
        return env.sendMessage(state.message)
          .cancellable(pageID: pageID, id: CancelID.requestSendMessage, cancelInFlight: true)

      case .fetchMessage(let result):
        switch result {
        case .success(let item):
          let (newFetchMessage, newPrompt) = env.proceedNewMessage(state, item)
          state.fetchMessage = newFetchMessage
          state.message = newPrompt
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

// MARK: MainStore.Action

extension MainStore {
  enum Action: BindableAction, Equatable {
    case teardown
    case binding(BindingAction<State>)

    case sendMessage
    case fetchMessage(Result<MessageScope, CompositeErrorDomain>)
    case throwError(CompositeErrorDomain)
  }
}

// MARK: MainStore.CancelID

extension MainStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestSendMessage
  }
}
