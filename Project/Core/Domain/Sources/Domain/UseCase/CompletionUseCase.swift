import Foundation
import Combine

public protocol CompletionUseCase {
  var sendMessage: (String) -> AnyPublisher<CompletionEntity.Response, CompositeErrorDomain> { get }
}
