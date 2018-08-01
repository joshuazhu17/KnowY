//
//  ReflectionTableViewController.swift
//  KnowY
//
//  Created by Joshua Zhu on 7/24/18.
//  Copyright © 2018 joshuazhu. All rights reserved.
//

import UIKit

class ReflectionTableViewController: UITableViewController {
    
    var goal: Goal?
    
    var reflections = [Reflection]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindWithSegueToReflectionTableViewController(_ segue: UIStoryboardSegue) {
        guard let goal = goal else {return}
        if let uuid = goal.uuid {
            reflections = CoreDataHelper.retrieveReflections(uuid: uuid)
        }
        else {
            reflections = [Reflection]()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let goal = goal else {return}
        
        if let uuid = goal.uuid {
            reflections = CoreDataHelper.retrieveReflections(uuid: uuid)
        }
        else {
            reflections = [Reflection]()
        }
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
        return reflections.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReflectionTableViewCell", for: indexPath) as? ReflectionTableViewCell else { return ReflectionTableViewCell() }

        // Configure the cell...
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MM/dd/yy"
        
        let reflection = reflections[indexPath.row]
        if let date = reflection.date {
            cell.dateLabel.text = formatter.string(from: date)
        }
        else {
            cell.dateLabel.text = "Unkown date"
        }
        if reflection.success {
            cell.successLabel.text = "Success"
        }
        else {
            cell.successLabel.text = "Failure"
        }

        return cell
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let goal = goal else {return}
            let reflection = reflections[indexPath.row]
            CoreDataHelper.delete(reflection: reflection)
            if let uuid = goal.uuid {
                reflections = CoreDataHelper.retrieveReflections(uuid: uuid)
            }
            else {
                fatalError("goal doesn't have a uuid")
            }
        }
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case "newReflection":
            print("new reflection")
            guard let destination = segue.destination as? EditReflectionViewController else {return}
            destination.goal = goal
            
        default:
            print("unidentified segue in reflection table view controller")
        }
    }
    

}
