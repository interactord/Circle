import Foundation

public struct ConfigurationRepository {
  public let apiURL: String
  public let model: String

  public init(apiURL: String, model: String) {
    self.apiURL = apiURL
    self.model = model
  }
}
