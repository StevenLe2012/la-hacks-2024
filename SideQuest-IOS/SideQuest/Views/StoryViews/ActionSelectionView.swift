//
//  ActionSelectionView.swift
//  SideQuest
//
//  Created by Atlas on 4/20/24.
//

import SwiftUI

struct ActionSelectionView: View {
    @Binding var actions: [UserAction]
    var buttonAction: (UserAction) -> Void
    
    var body: some View {
        VStack{
            Text("What should you do?")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
            ForEach(actions, id: \.action) { option in
              
                {
                    HStack{
                        Text(option.action)
                        Text("\(option.money.asCurrencyString())")
                    }.frame(maxWidth: 350)
                })
                .buttonStyle(PillButtonStyle())
                .padding(5)
            }
            Text("")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(5)
        }
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 25).fill( ColorUtils.themeColor))
    }
}

#Preview {
    ActionSelectionView(actions: .constant( MockStoryData.storyNode1.options), buttonAction: { action in
        print("\(action.action)")
        
    })
}
