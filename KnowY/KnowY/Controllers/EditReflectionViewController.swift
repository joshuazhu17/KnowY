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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case "done":
            if let reflection = reflection {
                reflection.details = detailsTextView.text
                if successSegmentedControl.selectedSegmentIndex == 0 {
                    reflection.success = true
                }
                else {
                    reflection.success = false
                }
                CoreDataHelper.saveGoal()
            }
            else {
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
            }
        default:
            print("unidentified segue in edit reflection view controller")
        }
    }
    

}
