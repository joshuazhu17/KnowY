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
        let reflections = self.retrieveReflections(uuid: goal.uuid!)
        for r in reflections {
            if r.goaluuid! == goal.uuid! {
                self.delete(reflection: r)
            }
        }
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
            let results = try context.fetch(fetchRequest).sorted(by: { (g1, g2) -> Bool in
                guard let date1 = g1.reminderTime else {return false}
                guard let date2 = g2.reminderTime else {return true}
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "H m"
                
                let time1 = formatter.string(from: date1).split(separator: " ").compactMap({ (s) -> Int? in
                    return Int(s)
                })
                let time2 = formatter.string(from: date2).split(separator: " ").compactMap({ (s) -> Int? in
                    return Int(s)
                })
                
                if time1[0] < time2[0] {
                    return true
                }
                else if time1[0] > time2[0] {
                    return false
                }
                else {
                    if time1[1] <= time2[1] {
                        return true
                    }
                    return false
                }
            })
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
                let id = r.goaluuid ?? ""
                return id == uuid
            }).sorted(by: { (r1: Reflection, r2: Reflection) -> Bool in
                guard let date1 = r1.date else { return false }
                guard let date2 = r2.date else { return true }
                return date1 > date2
            })
            return results
        } catch let error {
            print("Could not fetch reflections: \(error.localizedDescription)")
            return [Reflection]()
        }
    }
}
