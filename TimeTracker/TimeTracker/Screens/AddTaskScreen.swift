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
    var editTask: TaskObject?
    @State var name: String = ""
    @State var goal: String = ""
    
//    init(userId: String, edit task: TaskObject?, uploadTask: (TaskObject) -> Void) {
//        self.userId = userId
//        self.name = task?.name ?? ""
//        self.goal = task
//        self.uploadTask = uploadTask
//    }
    
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
                    if var editTask {
                        editTask.edit(name: self.name, timeGoal: Double(self.goal))
                    } else {
                        let task = TaskObject(userId: self.userId, name: self.name, timeGoal: Double(self.goal))
                        uploadTask(task)
                    }
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
