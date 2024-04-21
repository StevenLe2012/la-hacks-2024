//
//  SelectedActionView.swift
//  SideQuest
//
//  Created by Atlas on 4/20/24.
//

import SwiftUI

struct SelectedActionView: View {
    @State var action: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("You decided to...")
                .font(.headline)
            Text(action)
        }
            .padding()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 25).fill( ColorUtils.themeColor))
    }
}

#Preview {
    SelectedActionView(action: "Try on a few different sweaters to see which one feels the best.")
}
