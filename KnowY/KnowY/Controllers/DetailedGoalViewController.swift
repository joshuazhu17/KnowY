//
//  DetailedGoalViewController.swift
//  KnowY
//
//  Created by Joshua Zhu on 7/23/18.
//  Copyright © 2018 joshuazhu. All rights reserved.
//

import UIKit

class DetailedGoalViewController: UIViewController {
    
    @IBOutlet weak var goalNameLabel: UILabel!
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var whyDescription: UILabel!
    @IBOutlet weak var beginButton: UIButton!
    var goal: Goal?
    
    @IBAction func unwindWithSegueToDetailedGoalViewController(_ segue: UIStoryboardSegue) {
        if segue.source is CountdownViewController {
            DispatchQueue.main.async() {
                self.performSegue(withIdentifier: "straightToNewReflection", sender: self)
            }
        }
        else if segue.source is EditGoalViewController {
            guard let vc = segue.source as? EditGoalViewController else {return}
            self.goal = vc.goal
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let goal = goal else {return}
        
        goalNameLabel.text = goal.goalName
        goalDescriptionLabel.text = goal.goalDescription
        whyDescription.text = goal.why
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        if let time = goal.reminderTime {
            timeLabel.text = formatter.string(from: time)
        }
        else {
            timeLabel.text = "Unknown time"
        }

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let goal = goal else {return}
        
        goalNameLabel.text = goal.goalName
        goalDescriptionLabel.text = goal.goalDescription
        whyDescription.text = goal.why
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        if let time = goal.reminderTime {
            timeLabel.text = formatter.string(from: time)
        }
        else {
            timeLabel.text = "Unknown time"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case "backFromDetailToTableGoal":
            print("back")
        case "editGoal":
            let destination = segue.destination as! EditGoalViewController
            destination.goal = goal
        case "beginTimer":
            print("Beginning timer")
        case "showReflections":
            let destination = segue.destination as! ReflectionTableViewController
            destination.goal = goal
        case "straightToNewReflection":
            guard let destination = segue.destination as? ReflectionTableViewController else {return}
            destination.goal = goal
            destination.fromTimer = true
        default:
            print("unexpected segue in DetailedGoalViewController")
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
