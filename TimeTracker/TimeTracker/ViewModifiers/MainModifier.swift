//
//  MainModifier.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/13/22.
//

import SwiftUI

struct MainModifier: ViewModifier {
    
    var title: String
    var showAddButton: Bool
    var showSettingsButton: Bool
    var showAddTimerOption: Bool
    var addTaskAction: () -> Void
    var addTimerAction: () -> Void
    var settingsAction: () -> Void
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: settingsAction) {
                        Label("Settings", systemImage: "gear")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Add Task", action: addTaskAction)
                        if showAddTimerOption {
                            Button("Add Timer", action: addTimerAction)
                            
                        }
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
    }
}
