import Combine
import Foundation

public protocol StreamUseCase {
  var sendMessage: (String) -> AnyPublisher<StreamEntity.Response, CompositeErrorDomain> { get }
}
