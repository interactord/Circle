import ComposableArchitecture
import Foundation

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
      }
    }
  }

}

extension MainStore {
  struct State: Equatable {
  }
}

extension MainStore {
  enum Action: BindableAction, Equatable {
    case teardown
    case binding(BindingAction<State>)
  }
}

extension MainStore {
  enum CancelID: Equatable, CaseIterable {
    case teardown
  }
}

