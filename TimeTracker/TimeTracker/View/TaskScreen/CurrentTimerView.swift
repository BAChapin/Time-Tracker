//
//  CurrentTimerView.swift
//  TimeTracker
//
//  Created by Brett Chapin on 12/5/22.
//

import SwiftUI

struct CurrentTimerView: View {
    
    var timer: TimeObject
    var cycler = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
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
        .onDisappear {
            print("CurrentTimerView disappearring")
            cycler.upstream.connect().cancel()
        }
    }
    
    private func timeString() -> String {
        return timer.totalTime.simpleFormat()
    }
    
}
