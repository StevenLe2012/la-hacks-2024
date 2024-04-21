//
//  ButtonStyles.swift
//  SideQuest
//
//  Created by Atlas on 4/20/24.
//

import Foundation
import SwiftUI

struct PillButtonStyle: ButtonStyle {
    var fillColor: Color = .clear // Background color of the button
    var borderColor: Color = .white // Border color
    var borderWidth: CGFloat = 2 // Border width

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .angle(cornerRadius: 25).fill(fillColor)) // Background shape
            .overlay(
                RoundedRectangle(cornerRadius: 25) // Outline shape
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Slight scale animation on press
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
