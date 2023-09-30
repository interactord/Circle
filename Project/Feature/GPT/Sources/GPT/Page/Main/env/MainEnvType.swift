import ComposableArchitecture
import Domain
import Foundation

protocol MainEnvType {
  var useCaseGroup: GPTSideEffect { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }

  var sendMessage: (String) -> Effect<MainStore.Action> { get }
}

extension MainEnvType {
  public var sendMessage: (String) -> Effect<MainStore.Action> {
    { message in
        .publisher {
          useCaseGroup.completionUseCase
            .sendMessage(message)
            .compactMap(\.choiceList.first?.text)
            .mapToResult()
            .receive(on: mainQueue)
            .map{ .fetchMessage($0) }
        }
    }
  }
}
