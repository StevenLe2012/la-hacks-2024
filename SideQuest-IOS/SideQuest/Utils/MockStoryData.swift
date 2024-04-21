//
//  MockStoryData.swift
//  SideQuest
//
//  Created by Atlas on 4/19/24.
//

import Foundation

struct MockStoryData {
    // Mock data for easier UI itereation and future unit tests
    static var storyOption1: UserAction = UserAction(action: "Help them out", money: 5)
    static var storyOption2: UserAction = UserAction(action: "Don't help them out", money: 10)
    static var storyOption3: UserAction = UserAction(action: "Fight them!", money: 15)
    static var storyOption4: UserAction = UserAction(action: "Buy some burgers", money: 20)
    static var storyNode1: StoryDataModel = StoryDataModel(story: "A very engaging story that is super-duper cool!A very engaging story that is super-duper coolA very engaging story that is super-duper coolA very engaging story that is super-duper coolA very engaging story that is super-duper coolA very engaging story that is super-duper cool",
                                                           options: [storyOption1,
                                                                     storyOption2,
                                                                     storyOption3,
                                                                     storyOption4])
}
