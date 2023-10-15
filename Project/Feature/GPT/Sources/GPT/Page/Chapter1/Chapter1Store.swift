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

      case .onTapSendMessage:
        state.fetchMessage.isLoading = true
        state.questionList.append(state.message) // 내가 질문 한 것에 대한 리스트
        return env.sendMessage(state.message)
          .cancellable(pageID: pageID, id: CancelID.reqeustSendMessage, cancelInFlight: true)

      case .onTapCancel:
        state.message = ""
        state.fetchMessage.isLoading = false
        return .cancel(pageID: pageID, id: CancelID.reqeustSendMessage)

      case .fetchMessage(let result):
        state.fetchMessage.isLoading = false
        switch result {
        case .success(let item):
          state.fetchMessage.value = item // 질문에 대한 합
          state.answerList.append(item)
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
      _fetchMessage = .init(.init(isLoading: false, value: .init()))
    }

    // (질문, 대답)이런 식으로 표현하고 싶은데.
//            @BindingState var itemList: [(String, String)] = []
    @BindingState var questionList: [String] = [] // 질문 리스트
    @BindingState var answerList: [String] = [] // 대답 리스트
    @BindingState var message = "" // 질문을 통해 GPT를 통해 fetch한 데이터를 포현하기 위해
    @Heap var fetchMessage: FetchState.Data<String>
  }
}

// MARK: Chapter1Store.Action

extension Chapter1Store {
  enum Action: BindableAction, Equatable {
    case teardown
    case binding(BindingAction<State>)

    case onTapSendMessage
    case onTapCancel

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
