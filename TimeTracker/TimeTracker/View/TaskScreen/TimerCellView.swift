//
//  TimerCellView.swift
//  TimeTracker
//
//  Created by Brett Chapin on 12/31/22.
//

import SwiftUI

struct TimerCellView: View {
    
    let timer: TimeObject
    
    var body: some View {
        HStack {
            Text(formattedDate())
            
            Spacer()
            
            Text(timer.totalTime.simpleFormat())
        }
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: Date(timeIntervalSince1970: timer.date))
    }
    
}

struct TimerCellView_Previews: PreviewProvider {
    static var previews: some View {
        TimerCellView(timer: TimeObject.testTimer)
    }
}
