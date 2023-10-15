import Foundation
import SwiftUI
import Markdown

struct DemoPage {
}

extension DemoPage {
  private var parserResult: ParserResult {
    var parser = MarkdownAttributedStringParser()
    return parser.parserResults(from: .init(
      parsing: markdownString)).first
    ?? .init()
  }
  
  private var markdownString: String {
   """
   ```swift
   let api = ChatGPTAPI(apiKey: "API_KEY")
   
   Task {
       do {
           let stream = try await api.sendMessageStream(text: "What is ChatGPT?")
           for try await line in stream {
               print(line)
           }
       } catch {
           print(error.localizedDescription)
       }
   }
   ```
   """
  }
}

extension DemoPage: View {
  var body: some View {
    CodeBlockView(parserResult: parserResult)
  }
}
