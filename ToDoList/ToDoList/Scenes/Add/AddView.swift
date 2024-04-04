//
//  AddView.swift
//  ToDoList
//
//  Created by Mahdi on 4/4/24.
//

import SwiftUI

struct AddView: View {
    
    let item: TaskItem?
    @StateObject private var dataController = DatabaseController.shared
    @State private var title: String = ""
    @State private var date = Date.now
    @Environment(\.presentationMode) var presentation

    var body: some View {
        HStack {
            VStack(spacing: 24) {
                
                VStack(spacing: 8) {
                    Text("Enter your task title")
                        .font(.headline)
                    TextField("Task Title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                DatePicker(selection: $date, in: Date.now...) {
                    Text("Select task date").font(.headline)
                }
                
                Button {
                    dataController.addNewTask(title: title.isEmpty ? "New task" : title,
                                              date: date,
                                              order: 0,
                                              id: UUID())
                    self.presentation.wrappedValue.dismiss()
                } label: {
                        Text("Add")
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                    }
                    .background(Color(red: 0, green: 0, blue: 0.5))
                    .clipShape(Capsule())
                Spacer()
            }
        }.padding()
    }
}



