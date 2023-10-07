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
            .map{ .fetchMessage($0) }
        }
    }
  }
}

//음성 파일 비쥬얼 할 수 있는 FFT 라이브러리를 swift코드로 작성해줘
