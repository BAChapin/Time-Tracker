//
//  TaskList.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/13/22.
//

import SwiftUI

struct TaskListView: View {
    
    @StateObject var viewModel: MainViewModel
    
    var body: some View {
        List($viewModel.tasks) { task in
            TaskCellView(task: task) { task in
                viewModel.navigateTo(task: task)
            }
            .listRowSeparator(.hidden)
        }
        .navigationDestination(for: Int.self) { i in
            TaskScreen(task: $viewModel.tasks[i])
        }
        .listStyle(.plain)
    }
}
