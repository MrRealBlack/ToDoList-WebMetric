//
//  ContentView.swift
//  ToDoList
//
//  Created by Mahdi on 4/4/24.
//

import SwiftUI
import CoreData

struct ListView: View {

    @StateObject 
    private var dataController = DatabaseController.shared
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order)],
                  predicate: NSPredicate(format: "status == %@", "done"))
    var doneItems: FetchedResults<TaskItem>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order)],
                  predicate: NSPredicate(format: "status == %@", "pending"))
    var pendingItems: FetchedResults<TaskItem>

    var body: some View {
        NavigationView {
            List(editActions: .move) {
                if !doneItems.isEmpty {
                    Section(header: Text(TaskStatus.done.rawValue)) {
                        ForEach(doneItems) { item in
                            ListItemView(item: item.toModel())
                                .swipeActions {
                                    Button {
                                        item.status = "pending"
                                        dataController.edit(item)
                                    } label: {
                                        Text("Undone")
                                    }
                                    
                                    Button(role: .destructive) {
                                        dataController.delete(item)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
                
                if !pendingItems.isEmpty {
                    Section(header: Text(TaskStatus.pending.rawValue)) {
                        ForEach(pendingItems) { item in
                            let data = item.toModel()
                            ListItemView(item: data)
                                .swipeActions {
                                    Button {
                                        item.status = "done"
                                        dataController.edit(item)
                                    } label: {
                                        Text("Done")
                                    }
                                    
                                    Button(role: .destructive) {
                                        dataController.delete(item)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
                
                if doneItems.isEmpty && pendingItems.isEmpty {
                    ContentUnavailableView {
                        Label("No Tasks!", systemImage: "note")
                    } description: {
                        Text("You can add tasks by add button")
                    } actions: {
                        NavigationLink(destination: AddView(item: nil)) {
                            Text("Add")
                        }
                    }
                }
            }
            .toolbar {
                if !doneItems.isEmpty || !pendingItems.isEmpty {
                    ToolbarItem {
                        NavigationLink(destination: AddView(item: nil)) {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
            }
            .navigationBarTitle(Text("My ToDo List"))
        }
    }
}

#Preview {
    ListView().environment(\.managedObjectContext, DatabaseController.preview.container.viewContext)
}
