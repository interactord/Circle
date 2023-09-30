import Foundation

// MARK: - HttpMethod

enum HttpMethod: Equatable {
  case get
  case post
}

extension HttpMethod {
  var rawValue: String {
    switch self {
    case .get: "GET"
    case .post: "POST"
    }
  }
}
