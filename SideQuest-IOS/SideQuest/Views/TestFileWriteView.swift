//
//  TestFileWriteView.swift
//  SideQuest
//
//  Created by Atlas on 4/19/24.
//

import Foundation
import SwiftUI

struct TestFileWriteView: View {
    let userHistoryManager = UserHistoryManager()
    @State var count = 0
    @State var fileContent = "Not loaded"
    
    var body: some View {
        VStack{
            HStack{
                Button("Write") {
                    userHistoryManager.append(newHistory: makeHistory())
                }
                Button("Load") {
                    fileContent = userHistoryManager.readFileContents()
                }
                Button("Delete") {
                    userHistoryManager.deleteFile()
                }
            }
            Text(fileContent)
        }
    }
    
    private func makeHistory() -> StoryHistoryEntry{
        count += 1
        return StoryHistoryEntry(type: .story, message: "hahaha")
    }
}
