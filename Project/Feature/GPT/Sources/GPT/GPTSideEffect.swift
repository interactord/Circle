import Domain
import Foundation

public protocol GPTSideEffect {
  var completionUseCase: CompletionUseCase { get }
  var streamUseCase: StreamUseCase { get }
}
