import SwiftUI

class AttributedTextViewModel: NSObject, ObservableObject, TextFormatControlPanelViewDelegate {
    @Published var textFormat: TextFormatWrapper
    var text: String
    
    init(text: String, textFormat: TextFormatWrapper) {
        self.text = text
        self.textFormat = textFormat
    }
    
    func onTextFormatChanged(_ textFormat: TextFormat, isUndoRedo: Bool) {
        self.textFormat = TextFormatWrapper(textFormat: textFormat)
    }
}

struct AttributedTextView: View {
    @ObservedObject var viewModel: AttributedTextViewModel
    
    var body: some View {
        Text(attributedString)
            .padding()
            .foregroundColor(.white)
    }
    
    private var attributedString: AttributedString {
        var textWithCase = viewModel.text
        if viewModel.textFormat.isUppercase {
            textWithCase = textWithCase.uppercased()
        } else if viewModel.textFormat.isLowercase {
            textWithCase = textWithCase.lowercased()
        } else if viewModel.textFormat.isProperCase {
            textWithCase = textWithCase.capitalized
        }

        var attributedString = AttributedString(textWithCase)
        
        if viewModel.textFormat.isBold && viewModel.textFormat.isItalic {
            attributedString.font = .system(size: UIFont.systemFontSize, weight: .bold).italic()
        } else if viewModel.textFormat.isBold {
            attributedString.font = .system(size: UIFont.systemFontSize, weight: .bold)
        } else if viewModel.textFormat.isItalic {
            attributedString.font = .system(size: UIFont.systemFontSize, weight: .regular).italic()
        } else {
            attributedString.font = .system(size: UIFont.systemFontSize, weight: .regular)
        }
        
        if viewModel.textFormat.isUnderline {
            attributedString.underlineStyle = .single
        }
        
        if viewModel.textFormat.isStrikethrough {
            attributedString.strikethroughStyle = .single
        }
        
        return attributedString
    }
}