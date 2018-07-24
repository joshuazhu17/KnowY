//
//  CoreDataHelper.swift
//  KnowY
//
//  Created by Joshua Zhu on 7/23/18.
//  Copyright © 2018 joshuazhu. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    } ()
    
    static func newGoal() -> Goal {
        let goal = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: context) as! Goal
        
        return goal
    }
    
    static func saveGoal() {
        do {
            try context.save()
        } catch let error {
            print("Could not save: \(error.localizedDescription)")
        }
        
    }
    
    static func delete(goal: Goal) {
        context.delete(goal)
        CoreDataHelper.saveGoal()
    }
    
    static func retrieveGoals() {
        
    }
}
