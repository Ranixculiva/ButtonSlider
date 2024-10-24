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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)
                    .padding(0.5)
                
                // Foreground (white part)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
//                    .border(.white, width: 4)
                    .mask(
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: geometry.size.height * fillPercentage)
                            .offset(y: geometry.size.height * (1 - fillPercentage) / 2)
                    )
                
                // Icon or Percentage
                if isDragging {
                    percentageText(geometry: geometry)
                } else {
                    iconView(geometry: geometry)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        dragOffset = value.translation.height
                        updateFillPercentage(geometry: geometry)
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
            }
        }
    }
    
    private func iconView(geometry: GeometryProxy) -> some View {
        ZStack {
            Image(systemName: iconName)
                .foregroundColor(.white)
                .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.5))
            Image(systemName: iconName)
                .foregroundColor(.black)
                .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.5))
                .mask(
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: geometry.size.height * fillPercentage)
                        .offset(y: geometry.size.height * (1 - fillPercentage) / 2)
                )
        }
    }
    
    private func percentageText(geometry: GeometryProxy) -> some View {
        ZStack {
            Text("\(Int(fillPercentage * 100))%")
                .foregroundColor(.white)
                .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.3))
                .fontWeight(.bold)
            Text("\(Int(fillPercentage * 100))%")
                .foregroundColor(.black)
                .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.3))
                .fontWeight(.bold)
                .mask(
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: geometry.size.height * fillPercentage)
                        .offset(y: geometry.size.height * (1 - fillPercentage) / 2)
                )
        }
    }
    
    private func updateFillPercentage(geometry: GeometryProxy) {
        let maxDrag = geometry.size.height * 1.5 // Allow 50% extra drag
        let newPercentage = 1 - (dragOffset + maxDrag / 2) / maxDrag
        fillPercentage = max(0, min(1, newPercentage))
    }
    
    private func updateIsOn() {
        isOn = fillPercentage >= threshold
    }
}
