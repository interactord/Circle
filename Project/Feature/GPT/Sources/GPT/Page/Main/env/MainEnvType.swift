import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - MainEnvType

protocol MainEnvType {
  var useCaseGroup: GPTSideEffect { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }

  var sendMessage: (String) -> Effect<MainStore.Action> { get }
  var proceedNewMessage: (MainStore.State, MainStore.MessageScope) -> (FetchState.Data<MainStore.MessageScope>, String) { get }
}

extension MainEnvType {
  var sendMessage: (String) -> Effect<MainStore.Action> {
    { message in
      .publisher {
        useCaseGroup.streamUseCase
          .sendMessage(message)
          .map { res -> MainStore.MessageScope in
            guard let pick = res.choiceList.first else { return .init() }

            return .init(
              content: pick.delta.content ?? "",
              isFinish: (pick.finishReason ?? "").lowercased() == "stop")
          }
          .mapToResult()
          .receive(on: mainQueue)
          .map { .fetchMessage($0) }
      }
    }
  }

  var proceedNewMessage: (MainStore.State, MainStore.MessageScope) -> (FetchState.Data<MainStore.MessageScope>, String) {
    { state, newValue in
      let merged = state.fetchMessage.value.merge(rawValue: newValue)
      return (
        .init(
          isLoading: !merged.isFinish,
          value: merged),
        merged.isFinish ? "" : state.message
      )
    }
  }
}

extension MainStore.MessageScope {
  fileprivate func merge(rawValue: Self) -> Self {
    .init(
      content: content + rawValue.content,
      isFinish: rawValue.isFinish)
  }
}


// 음성 파일 비쥬얼 할 수 있는 FFT 라이브러리를 swift코드로 작성해줘
