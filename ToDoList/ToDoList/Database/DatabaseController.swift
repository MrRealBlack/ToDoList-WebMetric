//
//  DatabaseController.swift
//  ToDoList
//
//  Created by Mahdi on 4/4/24.
//

import CoreData

class DatabaseController: ObservableObject {
    
    static let shared = DatabaseController()
    let container = NSPersistentContainer(name: "ToDoList")
    var context: NSManagedObjectContext!

    static var preview: DatabaseController = {
        let result = DatabaseController()
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = TaskItem(context: viewContext)
            newItem.date = Date()
            newItem.title = "Title"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    private init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        context = container.viewContext
    }
    
    func add(_ model: TaskItemModel) {
        let task = model.toManagedObjectModel(context: context)
        context.insert(task)
        saveContext()
    }
    
    func delete(_ item: TaskItem) {
        context.delete(item)
        saveContext()
    }
    
    func edit(_ item: TaskItem) {
        let request = TaskItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id?.uuidString ?? "")
        
        do {
            let data = try context.fetch(request)
            if let first = data.first {
                first.status = item.status
            }
            saveContext()
        } catch {
            print(error)
        }
    }
    
    func fetchAll() -> [TaskItem] {
        let request = TaskItem.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print(error)
            return []
        }
    }
    
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
}
