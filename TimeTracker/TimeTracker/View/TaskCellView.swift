//
//  TaskCellView.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/13/22.
//

import SwiftUI

struct TaskCellView: View {
    
    @Binding var task: TaskObject
    var action: (TaskObject) -> Void
    
    var body: some View {
        Button {
            action(task)
        } label: {
            HStack {
                Text(task.name)
                    .font(.caption)
                    .padding(.leading)
                Spacer()
                Image(systemName: "chevron.right")
                    .padding(.trailing)
            }
        }
        .padding(.vertical)
        .background(task.isActive ? Color.blue.opacity(0.3) : Color.gray.opacity(0.3))
        .cornerRadius(10)
    }
}
