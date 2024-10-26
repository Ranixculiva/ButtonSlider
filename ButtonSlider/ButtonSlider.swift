//
//  TextFormatControlPanelView.swift
//  TextControlPanel
//
//  Created by Ranix on 2024/10/16.
//

import SwiftUI

struct ButtonSlider: View {
    @Binding var isOn: Bool
    @Binding var fillPercentage: CGFloat
    @State private var isDragging = false
    @State private var dragOffset: CGFloat = 0
    let iconName: String
    let threshold: CGFloat
    let itemWidth: CGFloat
    let itemHeight: CGFloat
    
    var onTap: (() -> Void)?
    var onDrag: ((CGFloat) -> Void)?
    
    @GuidelinePixelValueConvertor(wrappedValue: IS_IPAD ? 7 : 8) var cornerRadius: CGFloat
    @GuidelinePixelValueConvertor(wrappedValue: IS_IPAD ? 29.38 : 33.58) var iconWidth: CGFloat
    @GuidelinePixelHeightValueConvertor(wrappedValue: IS_IPAD ? 26.25 : 30) var iconHeight: CGFloat
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.25))
                .frame(width: itemWidth, height: itemHeight)
                .padding(0.5)
            
            // Foreground
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: itemWidth, height: itemHeight)
                .mask(
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: itemHeight * fillPercentage)
                        .offset(y: itemHeight * (1 - fillPercentage) / 2)
                )
            
            // Icon or Percentage
            if isDragging {
                percentageText()
            } else {
                iconView()
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    isDragging = true
                    dragOffset = value.translation.height
                    updateFillPercentage()
                    updateIsOn()
                    onDrag?(dragOffset)
                }
                .onEnded { _ in
                    isDragging = false
                    dragOffset = 0
                    updateIsOn()
                }
        )
        .onTapGesture {
            isOn.toggle()
            fillPercentage = isOn ? 1 : 0
            onTap?()
        }
    }
    
    private func iconView() -> some View {
        ZStack {
            if let image = UIImage(named: iconName) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: iconWidth, height: iconHeight)
                    .foregroundColor(.white)
                Image(uiImage: image)
                    .resizable()
                    .frame(width: iconWidth, height: iconHeight)
                    .foregroundColor(.black)
                    .mask(
                        Rectangle()
                            .fill(Color.black)
                            .frame(height: itemHeight * fillPercentage)
                            .offset(y: itemHeight * (1 - fillPercentage) / 2)
                    )
            }
        }
    }
    
    private func percentageText() -> some View {
        ZStack {
            Text("\(Int(fillPercentage * 100))%")
                .bold()
                .foregroundColor(.white)
                .frame(width: itemWidth, height: itemHeight)
            Text("\(Int(fillPercentage * 100))%")
                .bold()
                .foregroundColor(.black)
                .frame(width: itemWidth)
                .mask(
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: itemHeight * fillPercentage)
                        .offset(y: itemHeight * (1 - fillPercentage) / 2)
                )
        }
    }
    
    private func updateFillPercentage() {
        let maxDrag = itemHeight * 1.5 // Allow 50% extra drag
        let newPercentage = 1 - (dragOffset + maxDrag / 2) / maxDrag
        fillPercentage = max(0, min(1, newPercentage))
    }
    
    private func updateIsOn() {
        isOn = fillPercentage >= threshold
    }
}

#Preview {
    ContentView()
}
