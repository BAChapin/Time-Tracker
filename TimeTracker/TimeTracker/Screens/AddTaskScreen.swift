//
//  AddTaskScreen.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/13/22.
//

import SwiftUI

struct AddTaskScreen: View {
    
    var userId: String
    var uploadTask: (TaskObject) -> Void
    @State var name: String = ""
    @State var goal: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                
                Text("Task Creation")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .frame(height: 65)
            
            Text("Task Name")
                .font(.title3)
                .fontWeight(.medium)
                .padding(.leading, 10)
            
            TextField("Name", text: $name)
                .roundedBorder(height: 40)
            
            Text("Weekly Time Goal")
                .font(.title3)
                .fontWeight(.medium)
                .padding(.leading, 10)
                .padding(.top, 15)
            
            TextField("(Optional)", text: $goal)
                .roundedBorder(height: 40)
                .keyboardType(.decimalPad)
            
            HStack {
                Spacer()
                
                Button {
                    let task = TaskObject(userId: self.userId, name: self.name, timeGoal: Double(self.goal))
                    uploadTask(task)
                } label: {
                    Text("Upload")
                        .frame(height: 30)
                        .padding(.horizontal)
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding(.top)
            
        }
        .padding(.horizontal)
        
        Spacer()
    }
}
