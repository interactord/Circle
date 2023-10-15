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

      case .onTapSendMessage:
        state.fetchMessage.isLoading = true
        let new: MessageScope = .init(messageID: UUID().uuidString, role: .user, content: state.message)
        state.chatList = state.chatList + [ new ]
        return env.sendMessage(new)
          .cancellable(pageID: pageID, id: CancelID.requestSendMessage, cancelInFlight: true)

      case .onTapCancel:
        state.message = ""
        state.fetchMessage.isLoading = false
        return .cancel(pageID: pageID, id: CancelID.requestSendMessage)

      case .fetchMessage(let result):
        switch result {
        case .success(let item):
          state.fetchMessage.isLoading = !item.isFinish
          state.chatList = state.chatList.merge(rawValue: item)
          state.message = ""
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
      _fetchMessage = .init(.init())
    }

    @BindingState var message = ""
    @Heap var fetchMessage: FetchState.Empty
    var chatList: [MessageScope] = []
  }

  struct MessageScope: Equatable, Identifiable {
    let messageID: String
    let role: Role
    let content: String
    let isFinish: Bool


    var id: String {
      [ role.rawValue + messageID ].joined(separator: "_")
    }

    init(messageID: String, role: Role, content: String = "", isFinish: Bool = true) {
      self.messageID = messageID
      self.role = role
      self.content = content
      self.isFinish = isFinish
    }
  }

  enum Role: String, Equatable {
    case user
    case ai
  }

}

// MARK: MainStore.Action

extension MainStore {
  enum Action: BindableAction, Equatable {
    case teardown
    case binding(BindingAction<State>)

    case onTapSendMessage
    case onTapCancel

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

extension [MainStore.MessageScope] {
  fileprivate func merge(rawValue: MainStore.MessageScope) -> Self {
    /// - Note: 없으니 추가해서 리턴
    guard self.first(where: { $0.id == rawValue.id }) != .none else { return self + [rawValue] }

    return reduce([]) { curr, next in
      guard next.id == rawValue.id else { return curr + [next] }
      return curr + [next.mutate(rawValue: rawValue)]
    }

//    /// - Note: 현재 있는 아이템에 컨텐츠 추가
//    let new = pick.mutate(rawValue: rawValue)
//    var newList = [MainStore.MessageScope]()
//
//    for item in self {
//      if item.id == new.id {
//        newList.append(new)
//      } else {
//        newList.append(item)
//      }
//    }
//    return newList
//
////    return self.map { $0.id == new.id ? new : $0 }
  }
}

extension MainStore.MessageScope {
  func mutate(rawValue: Self) -> Self {
    .init(
      messageID: rawValue.messageID,
      role: rawValue.role,
      content: content + rawValue.content,
      isFinish: rawValue.isFinish)
  }
}
