//
//  EditReflectionViewController.swift
//  KnowY
//
//  Created by Joshua Zhu on 7/24/18.
//  Copyright © 2018 joshuazhu. All rights reserved.
//

import UIKit

class EditReflectionViewController: UIViewController {
    
    var goal: Goal?
    var reflection: Reflection?
    var activeView: UITextView?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var successSegmentedControl: UISegmentedControl!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        
        detailsTextView.layer.cornerRadius = 12
        detailsTextView.layer.masksToBounds = true
        
        if let reflection = reflection {
            if reflection.success {
                successSegmentedControl.selectedSegmentIndex = 0
            }
            else {
                successSegmentedControl.selectedSegmentIndex = 1
            }
            let details = reflection.details ?? ""
            if details.isEmpty {
                detailsTextView.text = "Write details here"
                detailsTextView.textColor = UIColor.lightGray
            }
            else {
                detailsTextView.text = details
            }
        }
        else {
            detailsTextView.text = "Write details here"
            detailsTextView.textColor = UIColor.lightGray
        }

        // Do any additional setup after loading the view.
        
        detailsTextView.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditGoalViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
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
    

    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if let _ = reflection {
            self.performSegue(withIdentifier: "editReflectionDone", sender: self)
        }
        else {
            self.performSegue(withIdentifier: "newReflectionDone", sender: self)
        }
    }
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        if let _ = reflection {
            self.performSegue(withIdentifier: "editReflectionCanceled", sender: self)
        }
        else {
            self.performSegue(withIdentifier: "newReflectionCanceled", sender: self)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if detailsTextView.textColor == UIColor.lightGray {
            detailsTextView.text = ""
        }
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case "editReflectionDone":
            guard let reflection = reflection else {return}
            reflection.details = detailsTextView.text
            if successSegmentedControl.selectedSegmentIndex == 0 {
                reflection.success = true
            }
            else {
                reflection.success = false
            }
            self.reflection = reflection
            CoreDataHelper.saveGoal()
            
        case "newReflectionDone":
            let reflection = CoreDataHelper.newReflection()
            guard let goal = goal else {return}
            reflection.goaluuid = goal.uuid
            reflection.date = Date()
            reflection.details = detailsTextView.text
            if successSegmentedControl.selectedSegmentIndex == 0 {
                reflection.success = true
            }
            else {
                reflection.success = false
            }
            CoreDataHelper.saveGoal()
            
        case "editReflectionCanceled":
            print("Canceled editting")
            
        case "newReflectionCanceled":
            print("Canceled new reflection")
            
        default:
            print("unidentified segue in edit reflection view controller")
        }
    }
}

extension EditReflectionViewController: UITextViewDelegate {
    
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
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeView = self.activeView {
            self.scrollView.scrollRectToVisible(activeView.frame, animated: true)
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
        self.scrollView.isScrollEnabled = false
    }
    
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write details here"
            textView.textColor = UIColor.lightGray
        }
    }
}
