//
//  ListDoneView.swift
//  ToDoList
//
//  Created by Mahdi on 4/4/24.
//

import SwiftUI
import Foundation

struct ListDoneView: View {
    
    let item: DoneItem

    var body: some View {
        HStack {
            Text(item.title ?? "")
                .font(.headline)
                .foregroundStyle(.green)
            Text(item.date?.formatted() ?? "")
                .font(.footnote)
                .foregroundStyle(.green.opacity(0.5))
        }
    }
}
