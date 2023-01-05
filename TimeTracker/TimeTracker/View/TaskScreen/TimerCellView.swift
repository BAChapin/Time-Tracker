//
//  TimerCellView.swift
//  TimeTracker
//
//  Created by Brett Chapin on 12/31/22.
//

import SwiftUI
import Combine

struct TimerCellView: View {
    
    let timer: TimeObject
    @Binding var cycler: Publishers.Autoconnect<Timer.TimerPublisher>
    @State var elapsedTime = ""
    
    var body: some View {
        HStack {
            Text(formattedDate())
            
            Spacer()
            
            Text(elapsedTime)
        }
        .onAppear {
            elapsedTime = timer.totalTime.simpleFormat()
        }
        .onReceive(cycler) { _ in
            if timer.isActive {
                elapsedTime = timer.totalTime.simpleFormat()
            }
        }
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: Date(timeIntervalSince1970: timer.date))
    }
    
}
