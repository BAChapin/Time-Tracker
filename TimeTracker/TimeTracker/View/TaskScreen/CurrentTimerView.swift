//
//  CurrentTimerView.swift
//  TimeTracker
//
//  Created by Brett Chapin on 12/5/22.
//

import SwiftUI
import Combine

struct CurrentTimerView: View {
    
    var timer: TimeObject
    @Binding var cycler: Publishers.Autoconnect<Timer.TimerPublisher>
    @State var time: String = ""
    
    var body: some View {
        HStack {
            Text("Active Time Elapsed:")
                .padding(.leading, 10)
            
            Spacer()
            
            Text(time)
                .padding(.trailing, 10)
        }
        .frame(height: 65)
        .background(Color.blue.opacity(0.3))
        .cornerRadius(10)
        .padding(.horizontal, 10)
        .onReceive(cycler, perform: { _ in
            time = timeString()
        })
        .onAppear(perform: {
            time = timeString()
        })
    }
    
    private func timeString() -> String {
        return timer.totalTime.simpleFormat()
    }
    
}
