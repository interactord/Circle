import Foundation
import ComposableArchitecture
import Domain
import Architecture
import LinkNavigator

struct Chapter1EnvLive {
  let useCaseGroup: GPTSideEffect
  let mainQueue: AnySchedulerOf<DispatchQueue> = .main
}

extension Chapter1EnvLive: Chapter1EnvType { }
