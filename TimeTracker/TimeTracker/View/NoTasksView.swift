//
//  NoTasksView.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/12/22.
//

import SwiftUI

struct NoTasksView: View {
    var body: some View {
        VStack(spacing: 25) {
            VStack {
                Image(systemName: "clock.badge.exclamationmark")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 150))
                
                Text("You don't currently have any tasks to display. Tap the add button, in the top right corner, to add a new task.")
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
            }
            .padding(.all, 25)
            .background(Color.blue.opacity(0.3))
            .cornerRadius(16)
            .padding(.top, 25)
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct NoTasksView_Previews: PreviewProvider {
    static var previews: some View {
        NoTasksView()
    }
}
