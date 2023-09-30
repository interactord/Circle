import SwiftUI

extension View {
  public func ignoreNavigationBar() -> some View {
    navigationBarTitle("")
      .navigationBarHidden(true)
  }
}
