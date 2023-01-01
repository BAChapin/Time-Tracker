//
//  TaskScreen.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/16/22.
//

import SwiftUI

struct TaskScreen: View {
    
    @Binding var task: TaskObject
    
    var body: some View {
        VStack {
            if let timer = task.activeTimer {
                CurrentTimerView(timer: timer)
            }
            
            GoalProgressView(task: $task)
            
            List {
                ForEach(task.timers) { timer in
                    TimerCellView(timer: timer)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle(task.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: toggleTimer) {
                    Label("Start/Stop", systemImage: task.isActive ? "stop.fill" : "play.fill")
                        .foregroundColor(task.isActive ? .red : .green)
                }
            }
        }
        .padding(.top)
        .onAppear {
            print(task)
        }
    }
    
    func toggleTimer() {
        if task.isActive {
            task.stop()
        } else {
            task.start()
        }
    }
}
