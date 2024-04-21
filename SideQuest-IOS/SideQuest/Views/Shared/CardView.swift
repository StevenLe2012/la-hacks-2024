//
//  CardView.swift
//  SideQuest
//
//  Created by Atlas on 4/20/24.
//

import SwiftUI

struct CardView: View {
    let imageName: String
    let text: String
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            Image(systemName: imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
            Text(text)
                
        }  .foregroundColor(.white)
            .frame(width: 150, height: 150)
            .background(ColorUtils.themeColor)
            .cornerRadius(25)
    }
}

#Preview {
    CardView(imageName:  "heart", text: "Romance")
}
