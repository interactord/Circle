import ComposableArchitecture
import Domain
import Foundation

// MARK: - Chapter1EnvType

protocol Chapter1EnvType {
  var useCaseGroup: GPTSideEffect { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }

  var sendMessage: (String) -> Effect<Chapter1Store.Action> { get }
}

extension Chapter1EnvType {
  public var sendMessage: (String) -> Effect<Chapter1Store.Action> {
    { message in
      .publisher {
        useCaseGroup.completionUseCase
          .sendMessage(message)
          .compactMap(\.choiceList.first?.text)
          .mapToResult()
          .receive(on: mainQueue)
          .map { .fetchMessage($0) }
      }
    }
  }
}
