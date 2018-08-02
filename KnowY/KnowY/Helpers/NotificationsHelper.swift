//
//  NotificationsHelper.swift
//  KnowY
//
//  Created by Joshua Zhu on 7/27/18.
//  Copyright © 2018 joshuazhu. All rights reserved.
//

import Foundation
import UserNotifications

struct NotificationsHelper {
    static func createGoalReminder(name: String?, date: Date, goal: Goal?, uuid: String) {
        
        if let goal = goal {
            self.deleteGoal(goal: goal)
        }
        
        let content = UNMutableNotificationContent()
        content.title = name ?? "Your goal"
        content.body = "Check KnowY"
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "H m"
        
        let timeString = formatter.string(from: date)
        let hourandminute = timeString.split(separator: " ")
        
        dateComponents.hour = Int(hourandminute[0])
        dateComponents.minute = Int(hourandminute[1])
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.add(request) {(error) in
            if let error = error {
                fatalError("Fatal error: \(error.localizedDescription)")
            }
        }
        // This is just for debugging, print out the existing notifications
        /*
        notificationCenter.getPendingNotificationRequests { (notifications: [UNNotificationRequest]) in
            for n in notifications {
                //print(n.content)
                print(n.debugDescription)
                print("====================================")
                print("====================================")
            }
            print(notifications.count)
        }
        */
    }
    
    static func deleteGoal(goal: Goal) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [goal.uuid!])
    }
}
