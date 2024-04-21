//
//  SideQuestApp.swift
//  SideQuest
//
//  Created by Atlas on 4/14/24.
//

import SwiftUI

@main
struct SideQuestApp: App {
    init() {
           // Customizing unselected tab item appearance
           UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        NotificationManager.shared.ensureNotificationAuthorization(completion: {_,_ in })
//        NotificationManager.shared.scheduleNotification(title: "Next Story is ready!", body: "Find out what happened next!", timeInterval: TimeInterval(10))
    }
    var body: some Scene {
        WindowGroup {
            TabView {
                StoryView()
                    .tabItem {
                    Label("Story", systemImage: "bubble.right")
                    }
                SummaryView()
                    .tabItem {
                    Label("Summary", systemImage: "chart.pie")
                }
                TestFileWriteView()
                    .tabItem {
                    Label("Account", systemImage: "house")
                }
              
            }.accentColor(ColorUtils.themeColor)
        }
    }
}
