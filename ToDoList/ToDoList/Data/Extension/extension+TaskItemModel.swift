//
//  extension+TaskItemModel.swift
//  ToDoList
//
//  Created by Mahdi on 4/4/24.
//

import Foundation
import CoreData

extension TaskItemModel {
    func toManagedObjectModel(context: NSManagedObjectContext) -> TaskItem {
        let task = TaskItem(context: context)
        task.id = id
        task.order = Int16(order)
        task.date = date
        task.title = title
        task.status = status.rawValue
        return task
    }
}
