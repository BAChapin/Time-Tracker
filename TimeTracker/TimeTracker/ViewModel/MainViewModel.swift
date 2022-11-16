//
//  MainViewModel.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/10/22.
//

import SwiftUI

class MainViewModel: ObservableObject {
    
    @Published var tasks: [TimerTask] = []
    @Published var displayAddTaskSheet: Bool = false
    @Published var navigateToSettings: Bool = false
    private let service = FirebaseFirestoreService()
    
    func add(_ task: TimerTask) {
        service.add(task: task)
    }
    
    func fetchTasks(for userId: String) {
        service.fetchTasks(for: userId) { timerTasks in
            self.tasks = timerTasks
        }
    }
}
