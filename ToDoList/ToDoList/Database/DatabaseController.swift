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
    
    func addNewTask(title: String, date: Date, order: Int, id: UUID) {
        for item in fetchAllPendingTasks() {
            item.order += 1
            editPending(item)
        }
        
        let task = TaskItem(context: context)
        task.id = id
        task.order = Int16(order)
        task.date = date
        task.title = title
        context.insert(task)
        saveContext()
    }
    
    func addNewTask(doneItem: DoneItem) {
        for item in fetchAllPendingTasks() {
            item.order += 1
            editPending(item)
        }
        
        let task = TaskItem(context: context)
        task.id = doneItem.id
        task.order = 0
        task.date = doneItem.date
        task.title = doneItem.title
        context.insert(task)
        saveContext()
    }
    
    func addDone(_ item: TaskItem) {
        for item in fetchAllDoneTasks() {
            item.order += 1
            editDone(item)
        }
        
        let task = DoneItem(context: context)
        task.id = item.id
        task.order = 0
        task.date = item.date
        task.title = item.title
        context.insert(task)
        saveContext()
    }
    
    func deletePendingTask(_ item: TaskItem) {
        context.delete(item)
        saveContext()
    }
    
    func deleteDone(_ item: DoneItem) {
        context.delete(item)
        saveContext()
    }
    
    func editPending(_ item: TaskItem) {
        let request = TaskItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id?.uuidString ?? "")
        
        do {
            let data = try context.fetch(request)
            if let first = data.first {
                first.order = item.order
            }
            saveContext()
        } catch {
            print(error)
        }
    }
    
    func editDone(_ item: DoneItem) {
        let request = TaskItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id?.uuidString ?? "")
        
        do {
            let data = try context.fetch(request)
            if let first = data.first {
                first.order = item.order
            }
            saveContext()
        } catch {
            print(error)
        }
    }
    
    func fetchAllPendingTasks() -> [TaskItem] {
        let request = TaskItem.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print(error)
            return []
        }
    }
    
    func fetchAllDoneTasks() -> [DoneItem] {
        let request = DoneItem.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print(error)
            return []
        }
    }
    
    func rearrangePendingArray(fromIndex: Int, toIndex: Int) {
        var array = fetchAllPendingTasks().sorted(by: { $0.order < $1.order })
        
        if toIndex > array.count - 1 {
            let element = array.remove(at: fromIndex)
            array.append(element)
        } else {
            let element = array.remove(at: fromIndex)
            array.insert(element, at: toIndex)
        }
        
        for index in 0..<array.count {
            let item = array[index]
            item.order = Int16(index)
            editPending(item)
        }
    }
    
    func rearrangeDoneArray(fromIndex: Int, toIndex: Int) {
        var array = fetchAllDoneTasks().sorted(by: { $0.order < $1.order })
        
        if toIndex > array.count - 1 {
            let element = array.remove(at: fromIndex)
            array.append(element)
        } else {
            let element = array.remove(at: fromIndex)
            array.insert(element, at: toIndex)
        }
        
        for index in 0..<array.count {
            let item = array[index]
            item.order = Int16(index)
            editDone(item)
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
