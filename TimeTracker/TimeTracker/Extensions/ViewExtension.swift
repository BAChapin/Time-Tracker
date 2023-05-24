//
//  ViewExtension.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/6/22.
//

import SwiftUI

extension View {
    
    func roundedBorder(height: CGFloat = 40, lineWidth: CGFloat = 1, paddingInset: CGFloat = 10) -> some View {
        self.modifier(RoundedBorderModifier(height: height, lineWidth: lineWidth, paddingInset: paddingInset))
    }
    
    func mainNavBarAccessories(title: String = "Time Tracker",
                               showAddButton: Bool = true,
                               showSettingsButton: Bool = true,
                               showAddTimerOption: Bool = false,
                               addTaskAction: @escaping () -> Void,
                               addTimerAction: @escaping () -> Void,
                               settingsAction: @escaping () -> Void) -> some View {
        self.modifier(MainModifier(title: title,
                                   showAddButton: showAddButton,
                                   showSettingsButton: showSettingsButton,
                                   showAddTimerOption: showAddTimerOption,
                                   addTaskAction: addTaskAction,
                                   addTimerAction: addTimerAction,
                                   settingsAction: settingsAction))
    }
    
}
