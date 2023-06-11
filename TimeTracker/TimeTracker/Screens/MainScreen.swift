//
//  MainScreen.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/6/22.
//

import SwiftUI

struct MainScreen: View {
    
    @EnvironmentObject var environment: TimeEnvironment
    @ObservedObject var viewModel = MainViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.navPath) {
            if viewModel.tasks.isEmpty {
                NoTasksView()
                    .mainNavBarAccessories(addTaskAction: addTask, addTimerAction: addTimer, settingsAction: showSettings)
            } else {
                TaskListView(viewModel: viewModel)
                    .mainNavBarAccessories(showAddTimerOption: !viewModel.tasks.isEmpty, addTaskAction: addTask, addTimerAction: addTimer, settingsAction: showSettings)
            }

        }
        .ignoresSafeArea()
        .onAppear {
            Task {
                await viewModel.fetchTasks(for: environment.userId!)
            }
        }
        .sheet(isPresented: $viewModel.displayAddTaskSheet) {
            AddTaskScreen(userId: environment.userId!) { task in
                viewModel.add(task)
                viewModel.displayAddTaskSheet.toggle()
            }
            .presentationDetents([.medium])
        }
        .sheet(item: $viewModel.editIndex) { index in
            let editTask = viewModel.tasks[index]
            AddTaskScreen(userId: environment.userId!, uploadTask: { task in
                viewModel.editIndex = nil
            }, editTask: editTask)
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $viewModel.displayAddTimerSheet) {
            AddTimerScreen(tasks: $viewModel.tasks, selection: viewModel.tasks[0], addTimer: { task, startTime, endTime in
                viewModel.add(timerTo: task, startTime: startTime, endTime: endTime)
            })
                .presentationDetents([.medium])
        }
    }
    
    func addTask() {
        viewModel.displayAddTaskSheet.toggle()
    }
    
    func addTimer() {
        if !viewModel.tasks.isEmpty {
            viewModel.displayAddTimerSheet.toggle()
        }
    }
    
    func showSettings() {
        print("Settings Tapped")
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
