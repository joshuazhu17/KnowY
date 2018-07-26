//
//  EditGoalViewController.swift
//  KnowY
//
//  Created by Joshua Zhu on 7/24/18.
//  Copyright © 2018 joshuazhu. All rights reserved.
//

import UIKit
import UserNotifications

class EditGoalViewController: UIViewController {
    
    var goal: Goal?

    @IBOutlet weak var goalNameTextField: UITextField!
    @IBOutlet weak var goalDescriptionTextView: UITextView!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var whyDescriptionTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let goal = goal {
            goalNameTextField.text = goal.goalName
            goalDescriptionTextView.text = goal.goalDescription
            whyDescriptionTextView.text = goal.why
            reminderDatePicker.date = goal.reminderTime ?? Date()
        }
        else {
            goalNameTextField.text = ""
            goalDescriptionTextView.text = ""
            whyDescriptionTextView.text = ""
            reminderDatePicker.date = Date()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        let content = UNMutableNotificationContent()
        content.title = goal?.goalName ?? "Your goal"
        content.body = "Check KnowY"
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        let date = reminderDatePicker.date
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "H m"
        
        let timeString = formatter.string(from: date)
        let hourandminute = timeString.split(separator: " ")
        
        dateComponents.hour = Int(hourandminute[0])
        dateComponents.minute = Int(hourandminute[1])
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) {(error) in
            if let error = error {
                fatalError("Fatal error: \(error.localizedDescription)")
            }
        }
        
        switch identifier {
        case "done" where goal == nil:
            let newGoal = CoreDataHelper.newGoal()
            newGoal.goalName = goalNameTextField.text ?? ""
            newGoal.goalDescription = goalDescriptionTextView.text ?? ""
            newGoal.why = whyDescriptionTextView.text ?? ""
            newGoal.reminderTime = reminderDatePicker.date
            newGoal.uuid = uuid
            
            CoreDataHelper.saveGoal()
            
        case "done" where goal != nil:
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [(goal?.uuid)!])
            
            goal?.goalName = goalNameTextField.text ?? ""
            goal?.goalDescription = goalDescriptionTextView.text ?? ""
            goal?.why = whyDescriptionTextView.text ?? ""
            goal?.reminderTime = reminderDatePicker.date
            goal?.uuid = uuid
            
            CoreDataHelper.saveGoal()
            
        case "cancelToConfirmation":
            print ("canceled")
            
        default:
            print("Unexpected segue")
        }
        
    }
    

}
