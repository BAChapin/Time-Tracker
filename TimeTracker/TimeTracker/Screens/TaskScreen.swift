//
//  TaskScreen.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/16/22.
//

import SwiftUI

struct TaskScreen: View {
    
    @Binding var task: TaskObject
    @State var timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if let timer = task.activeTimer {
                CurrentTimerView(timer: timer, cycler: $timer)
            }
            
            GoalProgressView(task: $task, cycler: $timer)
            
            List {
                ForEach(task.timers) { timer in
                    TimerCellView(timer: timer, cycler: $timer)
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
        .onDisappear {
            timer.upstream.connect().cancel()
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
