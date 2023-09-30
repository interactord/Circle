import ComposableArchitecture
import Domain
import Foundation

protocol MainEnvType {
  var useCaseGroup: GPTSideEffect { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
}
