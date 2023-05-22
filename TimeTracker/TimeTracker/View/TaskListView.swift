//
//  TaskList.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/13/22.
//

import SwiftUI

struct TaskListView: View {
    
    @StateObject var viewModel: MainViewModel
    @Binding var editTask: TaskObject?
    
    var body: some View {
        List($viewModel.tasks) { task in
            TaskCellView(task: task) { task in
                viewModel.navigateTo(task: task)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button {
                    _editTask = task
                } label: {
                    Text("Edit")
                        .font(.headline)
                }
                .tint(.blue)
            }
            .listRowSeparator(.hidden)
        }
        .navigationDestination(for: Int.self) { i in
            TaskScreen(task: $viewModel.tasks[i])
        }
        .listStyle(.plain)
    }
    
    private mutating func beginEdit(task: Binding<TaskObject>) {
        _editTask = task
    }
}
