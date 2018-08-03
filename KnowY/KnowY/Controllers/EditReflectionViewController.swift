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

    @IBOutlet weak var successSegmentedControl: UISegmentedControl!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let reflection = reflection {
            if reflection.success {
                successSegmentedControl.selectedSegmentIndex = 0
            }
            else {
                successSegmentedControl.selectedSegmentIndex = 1
            }
            let details = reflection.details ?? ""
            detailsTextView.text = details
        }

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditGoalViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
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
