import Foundation
import Combine

public protocol StreamUseCase {
  var sendMessage: (String) -> AnyPublisher<StreamEntity.Response, CompositeErrorDomain> { get }
}
