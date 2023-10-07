import Combine
import Foundation

public protocol CompletionUseCase {
  var sendMessage: (String) -> AnyPublisher<CompletionEntity.Response, CompositeErrorDomain> { get }
}
