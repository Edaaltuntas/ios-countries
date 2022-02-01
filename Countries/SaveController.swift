//
//  SaveController.swift
//  Countries
//
//  Created by Eda Altuntas on 1.02.2022.
//

import Foundation
import CoreData
import UIKit

class SaveController {

    static func save(country: Datum) -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let item = NSEntityDescription.insertNewObject(forEntityName: "Saved", into: context)
        item.setValue(country.name, forKey: "name")
        item.setValue(country.code, forKey: "code")
        do {
           try context.save()
            return true
        }
        catch {
            return false
        }
    }
    
    static func get(name: String) -> NSManagedObject? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Saved")
        fetchRequest.predicate = NSPredicate(format: "name==%@", name)
        let objects = try! context.fetch(fetchRequest)
        for obj in objects as! [NSManagedObject] {
            return obj
        }
        return nil
    }
    
    static func exists(name: String) -> Bool {
        let obj : NSManagedObject? = get(name: name)
        return obj != nil
    }
    
    static func rem(name: String) -> Bool {
        let obj : NSManagedObject? = get(name: name)
        if obj != nil {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(obj!)
            do {
                try context.save()
                return true
            } catch {
            }
        }
        return false
    }
}
