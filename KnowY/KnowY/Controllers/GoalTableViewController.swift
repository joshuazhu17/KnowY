//
//  GoalTableViewController.swift
//  KnowY
//
//  Created by Joshua Zhu on 7/23/18.
//  Copyright © 2018 joshuazhu. All rights reserved.
//

import UIKit
import UserNotifications

class GoalTableViewController: UITableViewController {
    
    var goals = [Goal]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindWithSegueToGoalTableViewController(_ segue: UIStoryboardSegue) {
        goals = CoreDataHelper.retrieveGoals()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        goals = CoreDataHelper.retrieveGoals()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return goals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalTableViewCell", for: indexPath) as! GoalTableViewCell
        
        let goal = goals[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        cell.goalNameLabel.text = goal.goalName
        if let time = goal.reminderTime {
            cell.timeLabel.text = formatter.string(from: time)
        }
        else {
            cell.timeLabel.text = "Unknown time"
        }

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let goal = goals[indexPath.row]
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [goal.uuid!])
            CoreDataHelper.delete(goal: goal)
            goals = CoreDataHelper.retrieveGoals()
            
        } 
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case "showDetailedGoal":
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let destination = segue.destination as! DetailedGoalViewController
            destination.goal = CoreDataHelper.retrieveGoals()[indexPath.row]
        case "newGoal":
            print("new goal")
        default:
            print("unexpected segue in GoalTableViewController")
        }
    }
    

}
