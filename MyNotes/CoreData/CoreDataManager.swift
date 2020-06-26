//  CoreDataManager.swift
//  PrashanthThotaCodingMart
//
//  Created by Pace Wisdom on 23/06/20.
//  Copyright © 2020 Pace Wisdom. All rights reserved.
//


import Foundation
import CoreData

class CoreDataManager {
    
   static let shared = CoreDataManager()
    
    private init() { }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MyNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
   lazy var context = self.persistentContainer.viewContext
    
    func saveContext () {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func SaveAttachment(title:String?,body:String?,attachment:Data?,isSelected:Bool) {
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "NotesEntity", into: CoreDataManager.shared.context);
        
        if let titleStr = title{
            
            entity.setValue(titleStr, forKey: "title")
        }
        
        if let bodyStr = body{
            
            entity.setValue(bodyStr, forKey: "body")
        }
        
        
        entity.setValue(isSelected, forKey: "isSelected")
        
        if let attachmentData = attachment{
            entity.setValue(attachmentData, forKey: "attachment")
        }
        do
        {
            try context.save();
        }
        catch
        {
            
        }
    }
    
    func FetchMyNotes() -> [NotesEntity] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesEntity")
        
        do {
            
           return try context.fetch(fetchRequest) as? [NotesEntity] ?? []
        }
        catch {
            
            print("Error While Fetching User Data")
        }
        
        return []
        
    }
   
    func UpdateSelection(index:NSInteger,isSelected:Bool) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesEntity")
        
        do {
            
           let array = try context.fetch(fetchRequest) as? [NotesEntity] ?? []
            
            let note = array[index]
            
            note.isSelected = isSelected
            
        }
        catch {
            
            print("Error While Fetching User Data")
        }
        
        do
        {
            try CoreDataManager.shared.context.save();
        }
        catch
        {
            
        }
        
        
    }
    
    func RearrangeCoreDataList(index:NSInteger,isSelected:Bool) {
        
        var notes = NotesEntity()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesEntity")
        
        do {
            let array = try context.fetch(fetchRequest) as? [NotesEntity] ?? []
                         
            let objectToAdd = array[index]
            
            notes = objectToAdd
            
            print("Data",objectToAdd.body as Any)
            
            print("notes",notes.title as Any)
                       
            context.delete(array[index] as NSManagedObject)
            
            self.SaveAttachment(title: objectToAdd.title, body: objectToAdd.body, attachment: objectToAdd.attachment, isSelected: true)
            
//            let entity = NSEntityDescription.insertNewObject(forEntityName: "NotesEntity", into: CoreDataManager.shared.context);
//
//            entity.setValue(objectToAdd.title, forKey: "title")
//            entity.setValue(objectToAdd.body, forKey: "body")
//            entity.setValue(objectToAdd.attachment, forKey: "attachment")
//            entity.setValue(true, forKey: "isSelected")
//
//            do
//            {
//                try context.save();
//            }
//            catch
//            {
//
//            }
//
//            try context.save()
            
            
        } catch _ {
            // error handling
        }
    }

    
}
