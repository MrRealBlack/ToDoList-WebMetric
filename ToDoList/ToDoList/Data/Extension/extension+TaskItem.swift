//
//  extension+TaskItem.swift
//  ToDoList
//
//  Created by Mahdi on 4/4/24.
//

import Foundation

extension TaskItem {
    func toModel() -> TaskItemModel {
        TaskItemModel(id: id ?? UUID(),
                      order: Int(order),
                      title: title ?? "",
                      date: date ?? Date(),
                      status: TaskStatus(rawValue: status ?? "") ?? .pending)
    }
}
