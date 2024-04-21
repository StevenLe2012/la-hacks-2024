//
//  StoryViewModel.swift
//  SideQuest
//
//  Created by Atlas on 4/15/24.
//

import Foundation

@Observable class StoryViewModel {
    var story: String?
    var options: [UserAction] = []
    let storyGenerator: StoryGenerator
    var histories: [StoryHistoryEntry] = []
    var isLoading: Bool = false
    var showCountdown: Bool = false
    
    init(storyGenerator: StoryGenerator = HardcodedStoryGenerator()) {
        self.storyGenerator = storyGenerator
        print("StoryViewModel initialized with \(storyGenerator)")
    }
    
    func debugSkipWait() {
        startCountdown(seconds: 10)
        NotificationManager.shared.scheduleNotification(title: "Your side quest has an update!", body: "Find out what will happen next!", timeInterval: TimeInterval(10))
        Task{
            try await Task.sleep(nanoseconds:10 * 1_000_000_000)
            fetchNextStory()
        }
       
    }
    
    func fetchNextStory() {
        isLoading = true
        showCountdown = false
        Task {
            
            print("Starting to fetch a new story")
            let storyModel = await storyGenerator.fetchNewStory()
            print("New story fetched: \(storyModel.story)")
            await updateUI(storyModel: storyModel)
            await updateUI(isLoading: false)
           
        }
    }
    
    func onSelect(option: UserAction) {
        print("User selected option: \(option)")
        options = []
        isLoading = true
        startCountdown(seconds: 4*60*60)
        Task {
            await updateUI(newHistory: StoryHistoryEntry(type: .userSelectedAction, message: option.action))
            let result = await storyGenerator.onOptionSelected(action: option)
            await updateUI(isLoading: false)
            await updateUI(newHistory: StoryHistoryEntry(type: .resultFromAction, message: result.result))
            await updateUI(showCountdown: true)
        }
        
    }
    
    private func startCountdown(seconds: Int) {
        // Schedule notification
        // start countime view
        let currentTime = Date()
        let targetTime = Calendar.current.date(byAdding: .second, value: seconds, to: currentTime)!
        UserDefaults.standard.set(targetTime, forKey: "targetTime")
    }
    
    func remainingTime() -> TimeInterval {
        guard let targetTime = UserDefaults.standard.object(forKey: "targetTime") as? Date else {
            return 0
        }
        let currentTime = Date()
        return max(targetTime.timeIntervalSince(currentTime), 0)
    }
  
    
    private func updateUI(storyModel: StoryDataModel) async {
        await MainActor.run {
            self.histories.append(StoryHistoryEntry(type: .story, message: storyModel.story))
            self.options = storyModel.options
            print("UI updated with new story and options")
        }
    }
    
    private func updateUI(newHistory: StoryHistoryEntry) async {
        await MainActor.run {
            self.histories.append(newHistory)
            print("UI updated with new history entry")
        }
    }
    
    private func updateUI(isLoading: Bool) async {
        await MainActor.run {
            self.isLoading = isLoading
        }
    }
    
    private func updateUI(showCountdown: Bool) async {
        await MainActor.run {
            self.showCountdown = showCountdown
        }
    }
}
