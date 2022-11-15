//
//  TaskList.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/13/22.
//

import SwiftUI

struct TaskListView: View {
    
    @Binding var tasks: [TimerTask]
    
    var body: some View {
        List() {
            ForEach($tasks, id: \.id) { task in
                TaskCellView(task: task)
            }
        }
        .listStyle(.plain)
    }
}
