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
    @Published var displayAddTimerSheet: Bool = false
    @Published var editIndex: Int? = nil
    private let service = FirebaseFirestoreService()
    
    subscript(task: TaskObject) -> Int? {
        return tasks.firstIndex(of: task)
    }
    
    func navigateTo(task: TaskObject) {
        if let index = tasks.firstIndex(of: task) {
            navPath.append(index)
        }
    }
    
    func add(_ task: TaskObject) {
        tasks.append(task)
        service.add(task: task)
        self.navigateTo(task: task)
    }
    
    func add(timerTo task: TaskObject, startTime: TimeInterval, endTime: TimeInterval?) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].addTimer(startTime: startTime, endTime: endTime)
        displayAddTimerSheet.toggle()
    }
    
    func beginEdit(task: TaskObject) {
        let value = self[task]
        editIndex = value
    }
    
    @MainActor
    func fetchTasks(for userId: String) async {
        service.fetchTasks(for: userId) { changeType, task in
            switch changeType {
            case .added:
                var newTask = task
                if !self.tasks.contains(where: { $0.id == newTask.id }) {
                    Task {
                        await newTask.fetchTimers()
                        self.tasks.append(newTask)
                        self.tasks.sort { $0.created < $1.created }
                    }
                }
            case .modified:
                let modifiedTask = task
                if let index = self.tasks.firstIndex(where: { $0.id == modifiedTask.id }) {
                    self.tasks[index].name = modifiedTask.name
                    self.tasks[index].timeGoal = modifiedTask.timeGoal
                }
                print("Modified", task.name)
            case .removed:
                print("Removed", task.name)
            }
        }
    }
}
