import Foundation
import URLEncodedForm

extension Endpoint {
  var request: URLRequest? {
    baseURL
      .component?
      .apply(pathList: pathList)
      .apply(content: content)
      .request?
      .apply(httpMethod: httpMethod)
      .apply(content: content)
      .apply(header: header)
  }
}

extension String {
  fileprivate var component: URLComponents? {
    .init(string: self)
  }
}

extension URLComponents {
  fileprivate var request: URLRequest? {
    guard let url else { return .none }
    return .init(url: url)
  }

  fileprivate func apply(pathList: [String]) -> Self {
    var new = self
    new.path = ([path] + pathList).joined(separator: "/")
    return new
  }

  fileprivate func apply(content: Endpoint.HttpContent?) -> Self {
    guard let content else { return self }
    guard case .queryItemPath(let item) = content
    else { return self }

    var new = self
    let newQuery = item.encodeString()
    new.query = newQuery

    return new
  }

}

extension URLRequest {
  fileprivate func apply(content: Endpoint.HttpContent?) -> Self {
    guard let content else { return self }
    guard case .bodyItem(let item) = content else { return self }
    guard let data = try? JSONEncoder().encode(item) else { return self }

    var new = self
    new.setValue("application/json", forHTTPHeaderField: "Content-Type")
    new.httpBody = data
    return new
  }

  fileprivate func apply(httpMethod: HttpMethod) -> Self {
    var new = self
    new.httpMethod = httpMethod.rawValue
    return new
  }

  fileprivate func apply(header: [String: String]) -> Self {
    var new = self

    for headerItem in header {
      new.setValue(headerItem.value, forHTTPHeaderField: headerItem.key)
    }

    return new
  }
}
