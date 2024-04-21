//
//  LoadingIcon.swift
//  SideQuest
//
//  Created by Atlas on 4/20/24.
//

import SwiftUI
import ActivityIndicatorView

struct LoadingIcon: View {
    @Binding var isVisible: Bool
    var body: some View {
        if isVisible{
            VStack{
                ActivityIndicatorView(isVisible: $isVisible, type:  .scalingDots(count: 3, inset: 2))
                    .frame(width: 50.0, height: 50.0)
                Text("Mad Science is Happening.")
            } .foregroundColor(ColorUtils.themeColor)
        }
    }
}

#Preview {
    LoadingIcon(isVisible: .constant(true))
}
