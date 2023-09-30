import Foundation

struct Endpoint {
  let baseURL: String
  let pathList: [String]
  let httpMethod: HttpMethod
  let content: HttpContent?
  let header: [String: String]

  init(
    baseURL: String,
    pathList: [String],
    httpMethod: HttpMethod = .get,
    content: HttpContent?,
    header: [String: String] = [:])
  {
    self.baseURL = baseURL
    self.pathList = pathList
    self.httpMethod = httpMethod
    self.content = content
    self.header = header
  }
}
