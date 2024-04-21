//
//  GenerativeService.swift
//  SideQuest
//
//  Created by Atlas on 4/19/24.
//

import Foundation
import Alamofire

//TODO: Create HTTP calls to our backend API, the API should be LLM agnostic

struct GenerativeBackendService {
    let headers: HTTPHeaders = [
        "Content-Type": "application/json"
    ]
    
    // Function to perform a POST request
    func fetchNewStoryBasedOnHistory(userHistory: String) async throws -> StoryDataModel {
        // Log the function entry and the data being posted
        print("Starting postUserHistory with userHistory: \(userHistory)")
        
        // URL for the POST request
        let urlString = "https://sidequest-b88295c7c179.herokuapp.com/api/get_story"
        print("Using URL: \(urlString)") // Log the URL being used
        guard let url = URL(string: urlString) else {
            print("Error: Bad URL \(urlString)") // Log a bad URL error
            throw URLError(.badURL)
        }
        
        // Prepare the parameters
        let parameters: [String: String] = ["user_history": userHistory]
        print("Parameters for the request: \(parameters)") // Log the parameters
        
        // Alamofire request
        return try await withCheckedThrowingContinuation { continuation in
            print("Sending request to server...") // Log the request initiation
            AF.request(url,
                       method: .post,
                       parameters: parameters,
                       encoder: JSONParameterEncoder.default,
                       headers: headers)
            .responseDecodable(of: StoryDataModel.self) { response in
                print("Received response from server") // Log the receipt of a response
                switch response.result {
                case .success(let value):
                    print("POST request successful, response: \(value)") // Log successful response
                    continuation.resume(returning: value)
                case .failure(let error):
                    print("POST request failed with error: \(error)") // Log failure and the error
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // Function to perform a POST request
    func fetchResponseBasedOnUserAction(userHistory: String, userAction: UserAction) async throws -> ResultFromAction {
        // Log the function entry and the data being posted
        print("Starting fetchResponseBasedOnUserAction with userAction: \(userAction.action)")
        
        // URL for the POST request
        let urlString = "https://sidequest-b88295c7c179.herokuapp.com/api/get_result"
        print("Using URL: \(urlString)") // Log the URL being used
        guard let url = URL(string: urlString) else {
            print("Error: Bad URL \(urlString)") // Log a bad URL error
            throw URLError(.badURL)
        }
        
        // Prepare the parameters
        let parameters = ["story": ["user_history": userHistory],
                                            "action": ["action": userAction.action]]
        print("Parameters for the request: \(parameters)") // Log the parameters
        
        // Alamofire request
        return try await withCheckedThrowingContinuation { continuation in
            print("Sending request to server...") // Log the request initiation
            AF.request(url,
                       method: .post,
                       parameters: parameters,
                       encoder: JSONParameterEncoder.default,
                       headers: headers)
            .responseDecodable(of: ResultFromAction.self) { response in
                print("Received response from server") // Log the receipt of a response
                switch response.result {
                case .success(let value):
                    print("POST request successful, response: \(value)") // Log successful response
                    continuation.resume(returning: value)
                case .failure(let error):
                    print("POST request failed with error: \(error)") // Log failure and the error
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

