//
//  TaskItemModel.swift
//  ToDoList
//
//  Created by Mahdi on 4/4/24.
//

import Foundation

class TaskItemModel: Identifiable {
    var id: UUID
    var order: Int
    var title: String
    var date: Date
    var status: TaskStatus
    var datePreview: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
    
    init(id: UUID, order: Int, title: String, date: Date, status: TaskStatus) {
        self.id = id
        self.order = order
        self.title = title
        self.date = date
        self.status = status
    }
}
