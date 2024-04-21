//
//  StoryDataModel.swift
//  SideQuest
//
//  Created by Atlas on 4/15/24.
//

import Foundation

struct StoryDataModel: Codable {
    let story: String
    let options: [UserAction]
}

struct UserAction: Codable {
    let action: String
    let money: Float
}

struct ResultFromAction: Codable {
    let result: String
}

// Used to write and load messages for the UI, this should ideally be store on the backend in the future
struct StoryHistoryEntry: Encodable {
    let type: HistoryType
    let message: String
}

enum HistoryType: Encodable {
    case userSelectedAction
    case story
    case resultFromAction
}

