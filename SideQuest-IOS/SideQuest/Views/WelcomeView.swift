//
//  WelcomeView.swift
//  SideQuest
//
//  Created by Atlas on 4/20/24.
//

import SwiftUI

struct WelcomeView: View {
    @State var storyViewModel: StoryViewModel
    var body: some View {
        if storyViewModel.isLoading {
            LoadingIcon(isVisible: $storyViewModel.isLoading)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ColorUtils.backgroundColor)
            
        } else {
            VStack(spacing: 40) {
                VStack(alignment: .leading){
                    Text("Begin your SideQuest")
                        .font(.largeTitle)
                    Text("Make saving as easy as spending.")
                        .font(.title2)
                } .padding([.leading], 20)
                .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 100)
//                    .padding([.top],)
//                    .background(ColorUtils.themeColor.ignoresSafeArea())
                    .cornerRadius(25)
              
                Text("Select the genres you love:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorUtils.themeColor)
                    .padding([.leading], 20)
                HStack(spacing: 40){
                    CardView(imageName: "heart", text: "Romance")
                    CardView(imageName: "pencil.slash", text: "Action")
                }
                HStack(spacing: 40){
                    CardView(imageName: "lasso.badge.sparkles", text: "Fantasy")
                    CardView(imageName: "scribble", text: "Thriller")
                }
                
        
                Button("Start a new adventure now!") {
                    storyViewModel.fetchNextStory()
                }.buttonStyle(PillButtonStyle())
                    .padding()
            
            } .frame(maxWidth: .infinity, maxHeight: .infinity)
              
            
        }
    }
}

#Preview {
    WelcomeView(storyViewModel: StoryViewModel())
}
