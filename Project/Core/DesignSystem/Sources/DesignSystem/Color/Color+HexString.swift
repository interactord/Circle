import Foundation
import SwiftUI

extension Color {
  fileprivate static func generate(hex: Int, opacity: Double = 1.0) -> Self {
    let red = Double((hex >> 16) & 0xff) / 255
    let green = Double((hex >> 8) & 0xff) / 255
    let blue = Double((hex >> 0) & 0xff) / 255
    return .init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
  }
}

extension String {
  public func hexColor(opacity: Double = 1.0) -> Color {
    guard let hex = Int(self, radix: 16) else { return .clear }
    return .generate(hex: hex, opacity: opacity)
  }
}

extension Int {
  public func hexColor(opacity: Double = 1.0) -> Color {
    .generate(hex: self, opacity: opacity)
  }
}
