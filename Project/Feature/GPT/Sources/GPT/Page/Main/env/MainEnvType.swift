import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - MainEnvType

protocol MainEnvType {
  var useCaseGroup: GPTSideEffect { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }

  var sendMessage: (MainStore.MessageScope) -> Effect<MainStore.Action> { get }
}

extension MainEnvType {
  var sendMessage: (MainStore.MessageScope) -> Effect<MainStore.Action> {
    { scope in
      .publisher {
        useCaseGroup.streamUseCase
          .sendMessage(scope.content)
          .map { res -> MainStore.MessageScope in
            guard let pick = res.choiceList.first else { return .init(messageID: scope.messageID, role: .ai) }
            return .init(
              messageID: scope.messageID,
              role: .ai,
              content: pick.delta.content ?? "",
              isFinish: (pick.finishReason ?? "").lowercased() == "stop")
          }
          .mapToResult()
          .receive(on: mainQueue)
          .map { .fetchMessage($0) }
      }
    }
  }
}
