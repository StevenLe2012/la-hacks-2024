//
//  NotificationManager.swift
//  SideQuest
//
//  Created by Atlas on 4/15/24.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()  // Singleton instance
    
    private init() {}
    
    // Function to schedule a local notification
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval) {
        // Create the notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        // Create the trigger as a time interval
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        // Create the request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Add request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    // Function to ensure notification permissions
    func ensureNotificationAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                // Request authorization
                self.requestAuthorization(completion: completion)
            case .authorized, .provisional:
                // Already authorized, execute completion with true
                completion(true, nil)
            case .denied:
                // Permission denied, execute completion with false
                completion(false, nil)
            case .ephemeral:
                // Only applicable for app clip
                completion(false, nil)
            @unknown default:
                // Handle any new cases
                completion(false, nil)
            }
        }
    }
    
    // Function to request notification permissions
    private func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            completion(granted, error)
        }
    }
    
    
}
