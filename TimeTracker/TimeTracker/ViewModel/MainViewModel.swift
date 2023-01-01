//
//  MainViewModel.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/10/22.
//

import SwiftUI
import FirebaseFirestore

class MainViewModel: ObservableObject {
    
    @Published var navPath = NavigationPath()
    @Published var tasks: [TaskObject] = []
    @Published var displayAddTaskSheet: Bool = false
    private let service = FirebaseFirestoreService()
    
    func navigateTo(task: TaskObject) {
        if let index = tasks.firstIndex(of: task) {
            navPath.append(index)
        }
    }
    
    func add(_ task: TaskObject) {
        service.add(task: task)
    }
    
    func add(timer: TimeObject) {
        service.add(timer: timer)
    }
    
    @MainActor
    func fetchTasks(for userId: String) async {
        service.fetchTasks(for: userId) { changeType, task in
            switch changeType {
            case .added:
                var newTask = task
                Task {
                    await newTask.fetchTimers()
                    self.tasks.append(newTask)
                    self.tasks.sort { $0.created < $1.created }
                }
            case .modified:
                print("Modified", task.name)
            case .removed:
                print("Removed", task.name)
            }
        }
    }
}
