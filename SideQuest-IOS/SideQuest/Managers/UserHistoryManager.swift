//
//  UserHistoryManager.swift
//  SideQuest
//
//  Created by Atlas on 4/19/24.
//

import Foundation

class UserHistoryManager {
    // The directory where the file will be stored
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    // The file name for storing data
    private let fileName = "history.txt"
    
    // Function to get file URL
    private func getFileURL() -> URL {
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    // Function to append a selection to the file
    func append(newHistory: StoryHistoryEntry) {
        let url = getFileURL()
    
        // Add a newline to separate entries
        var fullString = ""
        switch newHistory.type {
        case .userSelectedAction:
            fullString =  " The user decided to: " + newHistory.message
        case .story:
            fullString = newHistory.message
        case .resultFromAction:
            fullString = newHistory.message + "\n"
        }
        
        // Append data to the file
        if doesHistoryExist() {
            // If file exists, append to it
            if let fileHandle = FileHandle(forWritingAtPath: url.path) {
                
                fileHandle.seekToEndOfFile()
                fileHandle.write(fullString.data(using: .utf8)!)
                fileHandle.closeFile()
                
            }
        } else {
            // If the file does not exist, create it
            do {
                try fullString.write(to: url, atomically: true, encoding: .utf8)
            } catch {
                print("Error creating file: \(error)")
            }
        }
    }
    
    // Function to read the contents of the file
    func readFileContents() -> String {
        let url = getFileURL()
        do {
            // Read the entire file content
            let content = try String(contentsOf: url, encoding: .utf8)
            return content
        } catch {
            print("Error reading from file: \(error)")
            return "No previous chat history, start a new story!."
        }
    }
    
    func doesHistoryExist() -> Bool{
        let url = getFileURL()
        return  FileManager.default.fileExists(atPath: url.path)
    }
    
    func deleteFile() {
        let url = getFileURL()
        if doesHistoryExist() {
            do {
                try FileManager.default.removeItem(atPath: url.path)
            } catch let error {
                print("Error deleting file: \(error)")
            }
        }
    }
}

