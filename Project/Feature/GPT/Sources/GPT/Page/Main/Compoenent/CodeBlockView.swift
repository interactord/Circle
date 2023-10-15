import SwiftUI
import Markdown


struct CodeBlockView{
  let parserResult: ParserResult
  @State var isCopied = false
}

extension CodeBlockView {
  private var backgroundThemeColor: Color {
    "262626".hexColor()
  }
}

extension CodeBlockView: View {
  
  var body: some View {
    VStack(alignment: .leading) {
      
      HStack {
        if let codeBlockLanguage = parserResult.codeBlockLanguage {
          Text(codeBlockLanguage.capitalized)
            .font(.headline.monospaced())
            .foregroundStyle(.white)
        }
      }
      
      ScrollView(.horizontal, showsIndicators: true) {
        Text(parserResult.attributedString)
          .textSelection(.enabled)
          
      }
      .padding(8)

      
       
//      header
//        .padding(.horizontal)
//        .padding(.vertical, 8)
//        .background(Color(red: 9/255, green: 49/255, blue: 69/255))
//      
//      ScrollView(.horizontal, showsIndicators: true) {
//        Text(parserResult.attributedString)
//          .padding(.horizontal, 16)
//          .textSelection(.enabled)
//      }
    }
    .background(backgroundThemeColor)
    .cornerRadius(8)
  }
  
//  var header: some View {
//    HStack {
//      if let codeBlockLanguage = parserResult.codeBlockLanguage {
//        Text(codeBlockLanguage.capitalized)
//          .font(.headline.monospaced())
//          .foregroundColor(.white)
//      }
//      Spacer()
//      button
//    }
//  }
  
//  @ViewBuilder
//  var button: some View {
//    if isCopied {
//      HStack {
//        Text("Copied")
//          .foregroundColor(.white)
//          .font(.subheadline.monospaced().bold())
//        Image(systemName: "checkmark.circle.fill")
//          .imageScale(.large)
//          .symbolRenderingMode(.multicolor)
//      }
//      .frame(alignment: .trailing)
//    } else {
//      Button {
//        let string = NSAttributedString(parserResult.attributedString).string
//        UIPasteboard.general.string = string
//        withAnimation {
//          isCopied = true
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//          withAnimation {
//            isCopied = false
//          }
//        }
//      } label: {
//        Image(systemName: "doc.on.doc")
//      }
//      .foregroundColor(.white)
//    }
//  }
}


