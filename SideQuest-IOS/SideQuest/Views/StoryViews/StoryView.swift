//
//  StoryView.swift
//  SideQuest
//
//  Created by Atlas on 4/15/24.
//

import SwiftUI
import ActivityIndicatorView

struct StoryView: View {
    @State var storyViewModel = StoryViewModel(storyGenerator: NetworkedStoryGenerator())
    @State private var remainingSeconds: TimeInterval = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        NavigationView {
            if storyViewModel.histories.isEmpty {
                WelcomeView(storyViewModel: storyViewModel)
            } else {
                VStack{
                    ScrollView {
                        VStack {
                            ForEach(storyViewModel.histories, id: \.message) { storyEntry in
                                switch storyEntry.type {
                                case .story:
                                    Text(storyEntry.message)
                                        .foregroundColor(.gray)
                                        .padding()
                                case .userSelectedAction:
                                    SelectedActionView(action: storyEntry.message)
                                case .resultFromAction:
                                    Text(storyEntry.message)
                                        .foregroundColor(.gray)
                                        .padding()
                                    Divider()
                                        .background(Color.gray.opacity(0.5))
                                        .padding(.horizontal)
                                }
                            }
                            LoadingIcon(isVisible: $storyViewModel.isLoading)
                            if !storyViewModel.options.isEmpty {
                                ActionSelectionView(actions: $storyViewModel.options, buttonAction: storyViewModel.onSelect)
                            }
                            if storyViewModel.showCountdown {
                                VStack {
                                    Text("Next story coming in...")
                                    Text(timeString(time: remainingSeconds))
                                        .onAppear(perform: updateRemainingTime)
                                        .onReceive(timer) { _ in
                                            updateRemainingTime()
                                        }
                                } .foregroundColor(ColorUtils.themeColor)
                            
                            }
                            Spacer()
                            
                        }
                    }
                }
                .navigationBarItems(leading:
                                        Text("SideQuest")
                    .font(.largeTitle)
                    .foregroundColor(ColorUtils.themeColor),
                                    trailing:  Button(action: {
                    // Your settings action here
                    storyViewModel.debugSkipWait()
                }) {
                    //                    Image(systemName: "play.fill")
                    Text("[Debug] Skip Wait")
                        .foregroundColor(ColorUtils.themeColor)
                }.disabled(!storyViewModel.showCountdown)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(ColorUtils.backgroundColor)
                
            }
        }
    }
    func updateRemainingTime() {
        remainingSeconds = storyViewModel.remainingTime()
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

#Preview {
    StoryView().preferredColorScheme(.dark)
}
