//
//  TodayStatsView.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/16/22.
//

import SwiftUI

struct TaskStatsView: View {
    
    let totalTime: TimeInterval
    let goalTime: TimeInterval
    let type: StatType
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            VStack(alignment: .center, spacing: 5){
                Text("\(type.insert) Time:")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                
                // Formatted Time (i.e. ## minutes or ## hours ## mins
                Text(formattedTime())
                    .font(.system(size: 14))
            }
            
            VStack(alignment: .center, spacing: 5) {
                Text("\(type.insert) Progress:")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                
                // Percentage of time
                // If type is .today, it is a percentage representing the amount of time the current day is of your total weekly time
                // If type is .current, it is a percentage represeting the amount of time for the week out of your specified goal
                Text(percentage())
                    .font(.system(size: 14))
            }
        }
    }
    
    private func formattedTime() -> String {
        let hours = Int(floor(totalTime.inHours))
        let minutes = Int(floor(totalTime.inMinutes)) % 60
        let hoursString = hours > 0 ? "\(hours) hour\(hours > 1 ? "s" : "") " : ""
        let minutesString = "\(minutes) min\(minutes > 1 ? "s": "")"
        
        return hoursString + minutesString
    }
    
    private func percentage() -> String {
        if goalTime == 0 {
            return "--%"
        } else {
            var percent: Double = 0.0
            if type == .today {
                percent = round((totalTime / goalTime) * 100)
            } else {
                percent = round((totalTime.inHours / goalTime) * 100)
            }
            return "\(String(format: "%.0f", percent))%"
        }
    }
}

struct TodayStatsView_Previews: PreviewProvider {
    static var previews: some View {
        TaskStatsView(totalTime: 197, goalTime: 10.0, type: .today)
    }
}
