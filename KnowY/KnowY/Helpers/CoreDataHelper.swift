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
    
    static func newReflection() -> Reflection {
        let reflection = NSEntityDescription.insertNewObject(forEntityName: "Reflection", into: context) as! Reflection
        
        return reflection
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
    
    static func delete(reflection: Reflection) {
        context.delete(reflection)
        CoreDataHelper.saveGoal()
    }
    
    static func retrieveGoals() -> [Goal] {
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error {
            print("Could not fetch: \(error.localizedDescription)")
            return [Goal]()
        }
    }
    
    static func retrieveReflections(uuid: String) -> [Reflection] {
        let fetchRequest = NSFetchRequest<Reflection>(entityName: "Reflection")
        do {
            let results = try context.fetch(fetchRequest).filter({ (r: Reflection) -> Bool in
                return r.goaluuid == uuid
            })
            return results
        } catch let error {
            print("Could not fetch reflections: \(error.localizedDescription)")
            return [Reflection]()
        }
    }
}
