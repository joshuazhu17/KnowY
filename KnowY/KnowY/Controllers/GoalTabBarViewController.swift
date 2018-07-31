//
//  GoalTabBarViewController.swift
//  KnowY
//
//  Created by Joshua Zhu on 7/30/18.
//  Copyright © 2018 joshuazhu. All rights reserved.
//

import UIKit

class GoalTabBarViewController: UITabBarController {
    
    var goal: Goal!
    
    override func viewWillAppear(_ animated: Bool) {
        let detailedGoalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailedGoalViewController") as! DetailedGoalViewController
        detailedGoalViewController.goal = goal
        detailedGoalViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        let reflectionTableViewController = ReflectionTableViewController()
        reflectionTableViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        let viewControllerList = [ detailedGoalViewController, reflectionTableViewController]
        viewControllers = viewControllerList
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
