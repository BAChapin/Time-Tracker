//
//  TaskCellView.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/13/22.
//

import SwiftUI

struct TaskCellView: View {
    
    @Binding var task: TimerTask
    
    var body: some View {
        HStack {
            Text(task.name)
                .padding(.leading)
            Spacer()
            Image(systemName: "chevron.right")
                .padding(.trailing)
        }
        .listRowSeparator(.hidden)
        .padding(.vertical)
        .background(Color.blue.opacity(0.3))
        .cornerRadius(10)
    }
}
