import Foundation
import ComposableArchitecture
import Domain
import Architecture
import LinkNavigator

struct MainEnvLive {
  let useCaseGroup: GPTSideEffect
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
}

extension MainEnvLive: MainEnvType { }
