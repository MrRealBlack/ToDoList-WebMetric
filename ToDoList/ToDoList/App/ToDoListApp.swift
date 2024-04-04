//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Mahdi on 4/4/24.
//

import SwiftUI

@main
struct ToDoListApp: App {
    let dataController = DatabaseController.shared

    var body: some Scene {
        WindowGroup {
            ListView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
