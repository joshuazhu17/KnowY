//
//  EditGoalViewController.swift
//  KnowY
//
//  Created by Joshua Zhu on 7/24/18.
//  Copyright © 2018 joshuazhu. All rights reserved.
//

import UIKit

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
            navigationController?.isNavigationBarHidden = true
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
        
        navigationController?.isNavigationBarHidden = false
        
        switch identifier {
        case "done" where goal == nil:
            let uuid = UUID().uuidString
            
            NotificationsHelper.createGoalReminder(name: goalNameTextField.text ?? "", date: reminderDatePicker.date, goal: goal, uuid: uuid)
            
            let newGoal = CoreDataHelper.newGoal()
            newGoal.goalName = goalNameTextField.text ?? ""
            newGoal.goalDescription = goalDescriptionTextView.text ?? ""
            newGoal.why = whyDescriptionTextView.text ?? ""
            newGoal.reminderTime = reminderDatePicker.date
            newGoal.uuid = uuid
            
            CoreDataHelper.saveGoal()
            
        case "done" where goal != nil:
            let uuid = UUID().uuidString
            
            NotificationsHelper.createGoalReminder(name: goalNameTextField.text ?? "", date: reminderDatePicker.date, goal: goal, uuid: uuid)
            
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
