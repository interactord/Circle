import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

// MARK: - MainEnvLive

struct MainEnvLive {
  let useCaseGroup: GPTSideEffect
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
}

// MARK: MainEnvType

extension MainEnvLive: MainEnvType { }
