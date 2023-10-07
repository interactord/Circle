import Foundation

var token: String {
  /// - Note: Env.json이 없으면 여기서 바로 토큰을 넣으시면 됩니다.
  let data = try? Data(contentsOf: Files.envJson.url)
  let obj = try? JSONDecoder().decode(ENV.self, from: data ?? .init())
  return obj?.apiKey ?? ""
}

// MARK: - ENV

private struct ENV: Codable, Equatable {
  let apiKey: String

  private enum CodingKeys: String, CodingKey {
    case apiKey = "api_key"
  }
}
