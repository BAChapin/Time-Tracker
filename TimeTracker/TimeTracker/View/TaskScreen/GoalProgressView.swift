//
//  GoalProgressView.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/16/22.
//

import SwiftUI

enum StatType: String {
    case today = "Today"
    case week = "Week"
    
    var insert: String {
        switch self {
        case .today: return "Today's"
        case .week: return "Week's"
        }
    }
}

struct GoalProgressView: View {
    
    @Binding var task: TaskObject
    @State var currentTab: StatType = .today
    
    var progress: TimeInterval {
        return task.weekProgress.inHours
    }
    var goal: TimeInterval {
        return task.timeGoal ?? 0
    }
    
    var body: some View {
        HStack {
            
            SemiCircleProgressView(progress: progress, goal: goal, progressColor: .green, progressBackground: .black.opacity(0.1))
            .frame(width: 150, height: 150)
            .offset(.init(width: 0, height: 10))
            
            Spacer()
            
            VStack {
                Picker("", selection: $currentTab) {
                    Text("Today")
                        .tag(StatType.today)
                    
                    Text("Week")
                        .tag(StatType.week)
                }
                .pickerStyle(.segmented)
                .padding(.bottom)
                
                switch currentTab {
                case .today:
                    TaskStatsView(totalTime: task.dayProgress, goalTime: task.weekProgress, type: .today)
                case .week:
                    TaskStatsView(totalTime: task.weekProgress, goalTime: task.timeGoal ?? 0, type: .week)
                }
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 10)
        .padding(.vertical, 15)
        .background(.gray.opacity(0.1))
        .frame(maxWidth: .infinity)
    }
}
