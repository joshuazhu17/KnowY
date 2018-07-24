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
        
        switch identifier {
        case "done" where goal == nil:
            let newGoal = CoreDataHelper.newGoal()
            newGoal.goalName = goalNameTextField.text ?? ""
            newGoal.goalDescription = goalDescriptionTextView.text ?? ""
            newGoal.why = whyDescriptionTextView.text ?? ""
            newGoal.reminderTime = reminderDatePicker.date
            
            CoreDataHelper.saveGoal()
            
        case "done" where goal != nil:
            goal?.goalName = goalNameTextField.text ?? ""
            goal?.goalDescription = goalDescriptionTextView.text ?? ""
            goal?.why = whyDescriptionTextView.text ?? ""
            goal?.reminderTime = reminderDatePicker.date
            
            CoreDataHelper.saveGoal()
            
        case "cancelToConfirmation":
            print ("canceled")
            
        default:
            print("Unexpected segue")
        }
        
    }
    

}
