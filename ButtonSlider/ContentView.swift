//
//  ContentView.swift
//  ButtonSlider
//
//  Created by Ranix on 2024/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isOn = false
    @State private var fillPercentage: CGFloat = 0.5
    
    private var attributedTextViewModel: AttributedTextViewModel
    private var textFormatControlPanelViewModel: TextFormatControlPanelViewModel
    
    init() {
        attributedTextViewModel = AttributedTextViewModel(text: "Hello world, this is a text example", textFormat: TextFormatWrapper())
        textFormatControlPanelViewModel = TextFormatControlPanelViewModel()
        textFormatControlPanelViewModel.delegate = attributedTextViewModel

    }
    
    var body: some View {
        VStack {
            AttributedTextView(viewModel: attributedTextViewModel)
            TextFormatControlPanelView(viewModel: textFormatControlPanelViewModel)
//            ButtonSlider(isOn: $isOn, fillPercentage: $fillPercentage, iconName: "lightbulb.fill", threshold: 0.0)
//                .frame(width: 100, height: 50)
        }
        .background {
                    Color.black
                        .opacity(0.75)
                }
    }
}

#Preview {
    ContentView()
}
