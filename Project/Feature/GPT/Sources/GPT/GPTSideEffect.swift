import Foundation
import Domain

public protocol GPTSideEffect {
  var completionUseCase: CompletionUseCase { get }
  var streamUseCase: StreamUseCase { get }
}
