//
//  EditGoalViewController.swift
//  KnowY
//
//  Created by Joshua Zhu on 7/24/18.
//  Copyright © 2018 joshuazhu. All rights reserved.
//  With code from https://stackoverflow.com/questions/28813339/move-a-view-up-only-when-the-keyboard-covers-an-input-field

import UIKit
import NotificationCenter

class EditGoalViewController: UIViewController {
    
    var goal: Goal?
    
    var activeView: UITextView?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var goalNameTextField: UITextField!
    @IBOutlet weak var goalDescriptionTextView: UITextView!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var whyLabel: UILabel!
    @IBOutlet weak var whyDescriptionTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        goalNameTextField.layer.cornerRadius = 12
        goalDescriptionTextView.layer.cornerRadius = 12
        reminderDatePicker.layer.cornerRadius = 12
        reminderDatePicker.backgroundColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
        reminderDatePicker.layer.masksToBounds = true
        whyDescriptionTextView.layer.cornerRadius = 12
        whyLabel.layer.cornerRadius = 12
        whyLabel.layer.masksToBounds = true
        
        registerForKeyboardNotifications()
        
        goalDescriptionTextView.delegate = self
        whyDescriptionTextView.delegate = self
        
        if let goal = goal {
            goalNameTextField.text = goal.goalName
            goalDescriptionTextView.text = goal.goalDescription
            if goal.goalDescription!.isEmpty {
                goalDescriptionTextView.text = "Describe your goal (optional)"
                goalDescriptionTextView.textColor = UIColor.lightGray
            }
            whyDescriptionTextView.text = goal.why
            if goal.why!.isEmpty {
                whyDescriptionTextView.text = "Write why you're doing this here"
                whyDescriptionTextView.textColor = UIColor.lightGray
            }
            reminderDatePicker.date = goal.reminderTime ?? Date()
        }
        else {
            goalNameTextField.text = ""
            reminderDatePicker.date = Date()
            
            goalDescriptionTextView.text = "Describe your goal (optional)"
            goalDescriptionTextView.textColor = UIColor.lightGray
            whyDescriptionTextView.text = "Write why you're doing this here"
            whyDescriptionTextView.textColor = UIColor.lightGray
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditGoalViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        if let _ = goal {
            self.performSegue(withIdentifier: "editGoalCanceled", sender: self)
        }
        else {
            self.performSegue(withIdentifier: "newGoalCanceled", sender: self)
        }
    }
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if let _ = goal {
            self.performSegue(withIdentifier: "editGoalDone", sender: self)
        }
        else {
            self.performSegue(withIdentifier: "newGoalDone", sender: self)
        }
    }
    
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        if goalDescriptionTextView.textColor == UIColor.lightGray {
            goalDescriptionTextView.text = ""
        }
        if whyDescriptionTextView.textColor == UIColor.lightGray {
            whyDescriptionTextView.text = ""
        }
        
        switch identifier {
        case "newGoalDone":
            let uuid = UUID().uuidString
            
            NotificationsHelper.createGoalReminder(name: goalNameTextField.text ?? "", date: reminderDatePicker.date, goal: goal, uuid: uuid)
            
            let newGoal = CoreDataHelper.newGoal()
            newGoal.goalName = goalNameTextField.text ?? ""
            newGoal.goalDescription = goalDescriptionTextView.text ?? ""
            newGoal.why = whyDescriptionTextView.text ?? ""
            newGoal.reminderTime = reminderDatePicker.date
            newGoal.uuid = uuid
            newGoal.onOff = true
            
            CoreDataHelper.saveGoal()
            
        case "editGoalDone":
            NotificationsHelper.createGoalReminder(name: goalNameTextField.text ?? "", date: reminderDatePicker.date, goal: goal, uuid: goal!.uuid!)
            
            goal?.goalName = goalNameTextField.text ?? ""
            goal?.goalDescription = goalDescriptionTextView.text ?? ""
            goal?.why = whyDescriptionTextView.text ?? ""
            goal?.reminderTime = reminderDatePicker.date
            
            CoreDataHelper.saveGoal()
            
        case "newGoalCanceled":
            print ("canceled new goal")
            
        case "editGoalCanceled":
            print("canceled edit")
        default:
            print("Unexpected segue")
        }
        
    }
}

extension EditGoalViewController: UITextViewDelegate {
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        if let activeView = self.activeView {
            if activeView == goalDescriptionTextView {
                self.scrollView.scrollRectToVisible(activeView.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        //self.scrollView.isScrollEnabled = false
    }
    
    //
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.activeView = textView
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.activeView = nil
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == goalDescriptionTextView {
                textView.text = "Describe your goal (optional)"
            }
            else {
                textView.text = "Write why you're doing this here"
            }
            textView.textColor = UIColor.lightGray
        }
    }
    
}
