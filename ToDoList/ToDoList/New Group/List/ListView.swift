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
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order)])
    var doneItems: FetchedResults<DoneItem>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.order)])
    var pendingItems: FetchedResults<TaskItem>

    var body: some View {
        NavigationView {
            List {
                if !pendingItems.isEmpty {
                    Section(header: Text("Pending")) {
                        ForEach(pendingItems) { item in
                            ListItemView(item: item)
                                .swipeActions {
                                    Button {
                                        dataController.addDone(item)
                                        dataController.deletePendingTask(item)
                                    } label: {
                                        Text("Done")
                                    }
                                    
                                    Button(role: .destructive) {
                                        dataController.deletePendingTask(item)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }.onMove { from, to in
                            guard let fromIndex = from.first else { return }
                            dataController.rearrangePendingArray(fromIndex: fromIndex, toIndex: to)
                        }
                    }
                }
                
                if !doneItems.isEmpty {
                    Section(header: Text("Done")) {
                        ForEach(doneItems) { item in
                            ListDoneView(item: item)
                                .swipeActions {
                                    Button {
                                        dataController.addNewTask(doneItem: item)
                                        dataController.deleteDone(item)
                                    } label: {
                                        Text("Undone")
                                    }
                                    
                                    Button(role: .destructive) {
                                        dataController.deleteDone(item)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }.onMove { from, to in
                            guard let fromIndex = from.first else { return }
                            dataController.rearrangeDoneArray(fromIndex: fromIndex, toIndex: to)
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
