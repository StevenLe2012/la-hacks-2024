//
//  StoryGenerator.swift
//  SideQuest
//
//  Created by Atlas on 4/15/24.
//

import Foundation

// Receive UI events, call backend APIs
protocol StoryGenerator {
    func fetchNewStory() async -> StoryDataModel
    func onOptionSelected(action: UserAction) async -> ResultFromAction
}

class NetworkedStoryGenerator: StoryGenerator {
    static let shared = NetworkedStoryGenerator()
    let backend = GenerativeBackendService()
    let historyManager = UserHistoryManager()
    
    func onOptionSelected(action: UserAction) async -> ResultFromAction {
        print("Option Selected: \(action.action) with cost: \(action.money)")
        do {
            print("Write to user action to history")
            historyManager.append(newHistory: StoryHistoryEntry(type: .userSelectedAction, message: action.action)) // TODO, this is not ideal, it write to file, and load the entire file every time we do a call, it's hacky but quick
            let history = historyManager.readFileContents()
            print("Starting to fetch result from backend")
            let result = try await backend.fetchResponseBasedOnUserAction(userHistory: history, userAction: action)
            historyManager.append(newHistory: StoryHistoryEntry(type: .resultFromAction, message: result.result))
            return result
        } catch let error {
            print("Error when fetching new story: \(error)")
        }
        return ResultFromAction(result: "Error when fetching new story")
    }
    
    func fetchNewStory() async -> StoryDataModel {
        do {
            print("Load History")
            let history = historyManager.readFileContents()
            print("Starting to fetch story from backend")
            let result = try await backend.fetchNewStoryBasedOnHistory(userHistory: history)
            // Log successful API call
            print("Write to history")
            historyManager.append(newHistory: StoryHistoryEntry(type: .story, message: result.story)) // TODO, this is not ideal, it write to file, and load the entire file every time we do a call, it's hacky but quick
            return result
        } catch {
            // Log errors in detail
            print("Error when fetching new story: \(error)")
        }
        
        // Provide a default story and options if fetch fails
        return StoryDataModel(
            story: "Default story fetched from GPT",
            options: [UserAction(action: "Choose wisely", money: 20)]
        )
    }
}

class HardcodedStoryGenerator: StoryGenerator {
    static let shared = HardcodedStoryGenerator()
    
    func onOptionSelected(action: UserAction) -> ResultFromAction {
        // Detailed log for selected option
        print("Hardcoded Option Selected: \(action.action) with potential cost: \(action.money)")
        return ResultFromAction(result: "this is the consequences hahaha") 
    }
    
    func fetchNewStory() -> StoryDataModel {
        // Log fetching hardcoded story
        print("Fetching hardcoded story")
        return MockStoryData.storyNode1
    }
}
