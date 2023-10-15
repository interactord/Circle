import Foundation

struct ParserResult: Identifiable {
  
  let id = UUID()
  let attributedString: AttributedString
  let isCodeBlock: Bool
  let codeBlockLanguage: String?
  
  init(
    attributedString: AttributedString = .init(),
    isCodeBlock: Bool = false,
    codeBlockLanguage: String? = .none)
  {
    self.attributedString = attributedString
    self.isCodeBlock = isCodeBlock
    self.codeBlockLanguage = codeBlockLanguage
  }
}


