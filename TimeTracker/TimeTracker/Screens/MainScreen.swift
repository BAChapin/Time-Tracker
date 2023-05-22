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
    @State var editTask: TaskObject? = nil
    
    var body: some View {
        NavigationStack(path: $viewModel.navPath) {
            if viewModel.tasks.isEmpty {
                NoTasksView()
                    .mainNavBarAccessories(addTaskAction: addTask, addTimerAction: addTimer, settingsAction: showSettings)
            } else {
                TaskListView(viewModel: viewModel, editTask: $editTask)
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
        .sheet(item: $editTask) { task in
            AddTaskScreen(userId: environment.userId!, uploadTask: { task in
                viewModel.editTask = nil
            }, editTask: task)
        }
    }
    
    func addTask() {
        viewModel.displayAddTaskSheet.toggle()
    }
    
    func addTimer() {
        if !viewModel.tasks.isEmpty {
            print("Add Timer Tapped")
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
