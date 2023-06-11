//
//  AddTimerScreen.swift
//  TimeTracker
//
//  Created by Brett Chapin on 5/23/23.
//

import SwiftUI

struct AddTimerScreen: View {
    
    @Binding var tasks: [TaskObject]
    @State var selection: TaskObject
    @State var isActive = true
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    var addTimer: (TaskObject, TimeInterval, TimeInterval?) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                
                Text("Timer Creation")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .frame(height: 65)
            
            HStack {
                Text("Choose Task")
                
                Spacer()
                
                Picker("Task", selection: $selection) {
                    ForEach(tasks) { task in
                        Text(task.name).tag(task)
                    }
                }
                .tint(.black)
                .background(.gray.opacity(0.12))
                .cornerRadius(10)
            }
            .padding(.horizontal, 10)
            
            DatePicker("Start Time", selection: $startDate)
                .padding(.horizontal, 10)
                .padding(.top, 15)
            
            
            Toggle(isOn: $isActive) {
                Text("Is Active")
            }
            .padding(.horizontal, 10)
            .padding(.top, 15)
            
            if !isActive {
                DatePicker("End Time", selection: $endDate)
                    .padding(.horizontal, 10)
                    .padding(.top, 15)
            }
            
            HStack {
                Spacer()
                
                Button {
                    addTimer(selection, startDate.timeIntervalSince1970, isActive ? nil : endDate.timeIntervalSince1970)
                } label: {
                    Text(isActive ? "Start Timer" : "Add Timer")
                        .frame(height: 30)
                        .padding(.horizontal)
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding(.top)
            
            Spacer()
        }
    }
}

//struct AddTimerScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTimerScreen()
//    }
//}
