//
//  SemiCircleProgressView.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/16/22.
//

import SwiftUI

struct SemiCircleProgressView: View {
    
    var progress: Double
    var goal: Double
    var progressColor: Color = .cyan
    var progressBackground: Color = .black.opacity(0.1)
    
    private var percentage: Double {
        if goal > 1 {
            let perc = progress / goal
            return perc > 1 ? 1.0 : perc
        } else {
            return progress > 0 ? 1 : 0
        }
    }
    private var trimEnd: CGFloat {
        return (percentage * 0.7) + 0.15
    }
    private var statusMessage: String {
        if goal > 0 {
            return String(format: "%.1f of %.1f", progress, goal)
        }
        return String(format: "%.1f", progress)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.15, to: 0.85)
                .stroke(progressBackground, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .rotationEffect(.degrees(90))
            
            Circle()
                .trim(from: 0.15, to: trimEnd)
                .stroke(progressColor, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .rotationEffect(.degrees(90))
            
            VStack {
                Text(statusMessage)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .padding(.top, 5)
                
                Text("hours")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
            }
        }
    }
}

struct SemiCircleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        SemiCircleProgressView(progress: 6, goal: 12.0)
            .frame(width: 200, height: 200)
    }
}
