import Combine
import CombineExt
import Domain
import Foundation

extension Endpoint {
  func fetch<D: Decodable>(session: URLSession = .shared) -> AnyPublisher<D, CompositeErrorDomain> {
    makeRequest()
      .flatMap(session.fetchData)
      .decode(type: D.self, decoder: JSONDecoder())
      .catch { Fail(error: $0.serialized()) }
      .eraseToAnyPublisher()
  }
  
  func sse<D: Decodable>(session: URLSession = .shared) -> AnyPublisher<D, CompositeErrorDomain> {
    makeRequest()
      .flatMap(session.sseData)
      .decode(type: D.self, decoder: JSONDecoder())
      .catch { Fail(error: $0.serialized()) }
      .eraseToAnyPublisher()
  }
}

extension URLSession {
  fileprivate var fetchData: (URLRequest) -> AnyPublisher<Data, CompositeErrorDomain> {
    {
      self.dataTaskPublisher(for: $0)
        .tryMap { data, response in
          print(response.url?.absoluteString ?? "")
          
          guard let urlResponse = response as? HTTPURLResponse
          else { throw CompositeErrorDomain.invalidCasting }
          
          guard (200...299).contains(urlResponse.statusCode) else {
            throw CompositeErrorDomain.networkError(urlResponse.statusCode)
          }
          
          return data
        }
        .catch { Fail(error: $0.serialized()) }
        .eraseToAnyPublisher()
    }
  }
  
  fileprivate var sseData: (URLRequest) -> AnyPublisher<Data, CompositeErrorDomain> {
    { request in
        .create { observer in
          let task = Task {
            do {
              let (resultList, response) = try await self.bytes(for: request)
              
              guard let urlResponse = response as? HTTPURLResponse
              else {
                observer.send(completion: .failure(.invalidCasting))
                return
              }
              
              guard (200...299).contains(urlResponse.statusCode)
              else {
                observer.send(completion: .failure(.networkError(urlResponse.statusCode)))
                return
              }
              
              for try await line in resultList.lines {
                let data = "\(line.split(separator: "data: ").last ?? "")".data(using: .utf8) ?? .init()
                data.isValideJSON ? observer.send(data) : observer.send(completion: .finished)
              }
              
              observer.send(completion: .finished)
              
            } catch {
              observer.send(completion: .failure(.other(error)))
            }
          }
          return AnyCancellable { task.cancel() }
        }
    }
  }
}

extension Endpoint {
  private var makeRequest: () -> AnyPublisher<URLRequest, CompositeErrorDomain> {
    {
      Future<URLRequest, CompositeErrorDomain> { promise in
        guard let request else { return promise(.failure(.invalidCasting)) }
        
        return promise(.success(request))
      }
      .eraseToAnyPublisher()
    }
  }
}

extension Error {
  fileprivate func serialized() -> CompositeErrorDomain {
    guard let error = self as? CompositeErrorDomain else {
      return CompositeErrorDomain.other(self)
    }
    return error
  }
}

extension Data {
  var prettyPrintedJSONString: String {
    guard
      let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
      let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    else { return "json data malformed" }
    
    return String(data: jsonData, encoding: .utf8) ?? "nil"
  }
  
  var isValideJSON: Bool {
    do {
      let json = try JSONSerialization.jsonObject(with: self, options: .mutableContainers),
          _ = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
      return true
    } catch {
      return false
    }
  }
}
