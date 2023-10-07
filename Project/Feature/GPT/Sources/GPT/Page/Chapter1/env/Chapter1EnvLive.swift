import Architecture
import ComposableArchitecture
import Domain
import Foundation
import LinkNavigator

// MARK: - Chapter1EnvLive

struct Chapter1EnvLive {
  let useCaseGroup: GPTSideEffect
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
}

// MARK: Chapter1EnvType

extension Chapter1EnvLive: Chapter1EnvType { }
