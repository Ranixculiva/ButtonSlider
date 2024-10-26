//
//  TextFormatControlPanelView.swift
//  TextControlPanel
//
//  Created by Ranix on 2024/10/16.
//

import SwiftUI

struct TextFormatWrapper: Equatable {
    var isBold: Bool = false
    var isItalic: Bool = false
    var isUnderline: Bool = false
    var isStrikethrough: Bool = false
    var strikethroughLineThicknessFactor: CGFloat = 0
    private enum TextCase {
        case uppercase, lowercase, properCase, none
    }

    private var textCase: TextCase = .none

    var isUppercase: Bool {
        get { textCase == .uppercase }
        set { setTextCase(newValue ? .uppercase : textCase == .uppercase ? .none : textCase) }
    }

    var isLowercase: Bool {
        get { textCase == .lowercase }
        set { setTextCase(newValue ? .lowercase : textCase == .lowercase ? .none : textCase) }
    }

    var isProperCase: Bool {
        get { textCase == .properCase }
        set { setTextCase(newValue ? .properCase : textCase == .properCase ? .none : textCase) }
    }

    init(textFormat: TextFormat = MakeInitialTextFormat()) {
        self.isBold = textFormat.isBold.boolValue
        self.isItalic = textFormat.isItalic.boolValue
        self.isUnderline = textFormat.isUnderline.boolValue
        self.isStrikethrough = textFormat.isStrikethrough.boolValue
        self.isUppercase = textFormat.isUppercase.boolValue
        self.isLowercase = textFormat.isLowercase.boolValue
        self.isProperCase = textFormat.isProperCase.boolValue
        self.strikethroughLineThicknessFactor = CGFloat(textFormat.strikethroughLineThicknessFactor)
    }

    private mutating func setTextCase(_ caseType: TextCase) {
        textCase = caseType
    }
    
    func toObjCStruct() -> TextFormat {
        return TextFormat(
            isBold: ObjCBool(isBold),
            isItalic: ObjCBool(isItalic),
            isUnderline: ObjCBool(isUnderline),
            isStrikethrough: ObjCBool(isStrikethrough),
            isUppercase: ObjCBool(isUppercase),
            isLowercase: ObjCBool(isLowercase),
            isProperCase: ObjCBool(isProperCase),
            strikethroughLineThicknessFactor: CGFloat(strikethroughLineThicknessFactor)
        )
    }
}

@objc class TextFormatControlPanelViewModel: NSObject, ObservableObject {
    @Published var textFormat = TextFormatWrapper()
    weak var delegate: TextFormatControlPanelViewDelegate?
    
    func toggleProperty(_ toggle: (inout TextFormatWrapper) -> Void) {
        toggle(&textFormat)
        notifyDelegate(textFormat: textFormat)
    }

    fileprivate func notifyDelegate(textFormat: TextFormatWrapper, isUndoRedo: Bool = false) {
        delegate?.onTextFormatChanged(textFormat.toObjCStruct(), isUndoRedo: isUndoRedo)
    }
    
    @objc func update(_ textFormat: TextFormat, isUndoRedo: Bool) {
        self.textFormat = TextFormatWrapper(textFormat: textFormat)
        if isUndoRedo {
            notifyDelegate(textFormat: self.textFormat, isUndoRedo: true)
        }
    }
}

struct TextFormatControlPanelView: View {
    @GuidelinePixelValueConvertor(wrappedValue: IS_IPAD ? 90 : 60) var firstRowItemWidth: CGFloat
    @GuidelinePixelHeightValueConvertor(wrappedValue: IS_IPAD ? 28 : 32) var firstRowItemHeight: CGFloat
    @GuidelinePixelValueConvertor(wrappedValue: IS_IPAD ? 90 : 80) var secondRowItemWidth: CGFloat
    @GuidelinePixelHeightValueConvertor(wrappedValue: IS_IPAD ? 28 : 32) var secondRowItemHeight: CGFloat
    @GuidelinePixelValueConvertor(wrappedValue: IS_IPAD ? 30 : 14) var buttonHorizontalSpacing: CGFloat
    @GuidelinePixelHeightValueConvertor(wrappedValue: IS_IPAD ? 8 : 12) var buttonVerticalSpacing: CGFloat
    @GuidelinePixelHeightValueConvertor(wrappedValue: IS_IPAD ? 10 : 12) var verticalPadding: CGFloat
    @StateObject private var viewModel: TextFormatControlPanelViewModel
    
    init(viewModel: TextFormatControlPanelViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: buttonVerticalSpacing) {
            // first row
            HStack(spacing: buttonHorizontalSpacing) {
                TextFormatControlButtonView(
                    itemWidth: firstRowItemWidth,
                    itemHeight: firstRowItemHeight,
                    iconName: "btn_2lv_text_format_bold",
                    isSelected: viewModel.textFormat.isBold
                )
                    .onTapGesture {
                        viewModel.toggleProperty { textFormat in
                            textFormat.isBold.toggle()
                        }
                    }
                TextFormatControlButtonView(
                    itemWidth: firstRowItemWidth,
                    itemHeight: firstRowItemHeight,
                    iconName: "btn_2lv_text_format_italic",
                    isSelected: viewModel.textFormat.isItalic
                )
                    .onTapGesture {
                        viewModel.toggleProperty { textFormat in
                            textFormat.isItalic.toggle()
                        }
                    }
                TextFormatControlButtonView(
                    itemWidth: firstRowItemWidth,
                    itemHeight: firstRowItemHeight,
                    iconName: "btn_2lv_text_format_ul",
                    isSelected: viewModel.textFormat.isUnderline
                )
                    .onTapGesture {
                        viewModel.toggleProperty { textFormat in
                            textFormat.isUnderline.toggle()
                        }
                    }
                if isDeveloperMode {
                    ButtonSlider(
                        isOn: $viewModel.textFormat.isStrikethrough,
                        fillPercentage: $viewModel.textFormat.strikethroughLineThicknessFactor,
                        iconName: "btn_2lv_text_format_st",
                        threshold: 0.001,
                        itemWidth: firstRowItemWidth,
                        itemHeight: firstRowItemHeight) {
                            viewModel.notifyDelegate(textFormat: viewModel.textFormat)
                        } onDrag: { _ in
                            viewModel.notifyDelegate(textFormat: viewModel.textFormat)
                        }
                } else {
                    TextFormatControlButtonView(
                        itemWidth: firstRowItemWidth,
                        itemHeight: firstRowItemHeight,
                        iconName: "btn_2lv_text_format_st",
                        isSelected: viewModel.textFormat.isStrikethrough
                    )
                    .onTapGesture {
                        viewModel.toggleProperty { textFormat in
                            textFormat.isStrikethrough.toggle()
                        }
                    }
                }
            }
            
            // second row
            HStack {
                HStack(spacing: buttonHorizontalSpacing) {
                    TextFormatControlButtonView(
                        itemWidth: secondRowItemWidth,
                        itemHeight: secondRowItemHeight,
                        iconName: "btn_2lv_text_format_allcap",
                        isSelected: viewModel.textFormat.isUppercase
                    )
                        .onTapGesture {
                            viewModel.toggleProperty { textFormat in
                                textFormat.isUppercase.toggle()
                            }
                        }
                    TextFormatControlButtonView(
                        itemWidth: secondRowItemWidth,
                        itemHeight: secondRowItemHeight,
                        iconName: "btn_2lv_text_format_n",
                        isSelected: viewModel.textFormat.isProperCase
                    )
                        .onTapGesture {
                            viewModel.toggleProperty { textFormat in
                                textFormat.isProperCase.toggle()
                            }
                        }
                    TextFormatControlButtonView(
                        itemWidth: secondRowItemWidth,
                        itemHeight: secondRowItemHeight,
                        iconName: "btn_2lv_text_format_alls",
                        isSelected: viewModel.textFormat.isLowercase
                    )
                        .onTapGesture {
                            viewModel.toggleProperty { textFormat in
                                textFormat.isLowercase.toggle()
                            }
                        }
                }
            }
        }
            .padding(.vertical, verticalPadding)
    }
}

struct TextFormatControlButtonView: View {
    let itemWidth: CGFloat
    let itemHeight: CGFloat
    let iconName: String
    
    @GuidelinePixelValueConvertor(wrappedValue: IS_IPAD ? 7 : 8) var cornerRadius: CGFloat
    @GuidelinePixelValueConvertor(wrappedValue: IS_IPAD ? 29.38 : 33.58) var iconWidth: CGFloat
    @GuidelinePixelHeightValueConvertor(wrappedValue: IS_IPAD ? 26.25 : 30) var iconHeight: CGFloat
    var isSelected: Bool
    
    var body: some View {
        ZStack {
            // background
            Group {
                if isSelected {
                    Color.white
                } else {
                    Color.black
                        .opacity(0.25)
                }
            }
                .cornerRadius(cornerRadius)
                .frame(width: itemWidth, height: itemHeight)
            // icon
            if let iconImage = UIImage(named: iconName) {
                Image(uiImage: iconImage)
                    .resizable()
                    .frame(width: iconWidth, height: iconHeight)
                    .foregroundColor(isSelected ? .black : .white)
            }
        }
    }
}

#Preview(body: {
    ContentView()
})
