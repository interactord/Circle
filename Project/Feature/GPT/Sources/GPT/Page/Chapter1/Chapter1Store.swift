import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - Chapter1Store

struct Chapter1Store {

  let env: Chapter1EnvType
  private let pageID = UUID().uuidString
}

// MARK: Reducer

extension Chapter1Store: Reducer {

  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .merge(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0)
          })

      case .sendMessage:
        state.fetchMessage.isLoading = true
        return env.sendMessage(state.message)
          .cancellable(pageID: pageID, id: CancelID.reqeustSendMessage, cancelInFlight: true)

      case .fetchMessage(let result):
        state.fetchMessage.isLoading = false

        switch result {
        case .success(let message):
          state.fetchMessage.value = message
          state.message = ""
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .throwError(let error):
        print(error)
        return .none
      }
    }
  }

}

// MARK: Chapter1Store.State

extension Chapter1Store {
  struct State: Equatable {
    init() {
      _fetchMessage = .init(.init(isLoading: false, value: ""))
    }

    @BindingState var message = ""
    @Heap var fetchMessage: FetchState.Data<String>
  }

}

// MARK: Chapter1Store.Action

extension Chapter1Store {
  enum Action: BindableAction, Equatable {
    case teardown
    case binding(BindingAction<State>)

    case sendMessage
    case fetchMessage(Result<String, CompositeErrorDomain>)
    case throwError(CompositeErrorDomain)
  }
}

// MARK: Chapter1Store.CancelID

extension Chapter1Store {
  enum CancelID: Equatable, CaseIterable {
    case teardown
    case reqeustSendMessage
  }
}
