//
//  ListItemView.swift
//  ToDoList
//
//  Created by Mahdi on 4/4/24.
//

import SwiftUI
import Foundation

struct ListItemView: View {
    
    let item: TaskItem

    var body: some View {
        HStack {
            Text(item.title ?? "")
                .font(.headline)
            Text(item.date?.formatted() ?? "")
                .font(.footnote)
        }
    }
}
