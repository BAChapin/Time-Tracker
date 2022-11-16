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
        NavigationStack {
            if viewModel.tasks.isEmpty {
                NoTasksView()
                    .mainNavBarAccessories(addTaskAction: addTask, addTimerAction: addTimer, settingsAction: showSettings)
                    .navigationDestination(isPresented: $viewModel.navigateToSettings) {
                        SettingsScreen().environmentObject(environment)
                    }
            } else {
                TaskListView(tasks: $viewModel.tasks)
                    .mainNavBarAccessories(addTaskAction: addTask, addTimerAction: addTimer, settingsAction: showSettings)
                    .navigationDestination(isPresented: $viewModel.navigateToSettings) {
                        SettingsScreen().environmentObject(environment)
                    }
            }

        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.fetchTasks(for: environment.userId!)
        }
        .sheet(isPresented: $viewModel.displayAddTaskSheet) {
            AddTaskScreen(userId: environment.userId!) { task in
                viewModel.add(task)
                viewModel.displayAddTaskSheet.toggle()
            }
            .presentationDetents([.medium])
        }
    }
    
    func addTask() {
        viewModel.displayAddTaskSheet.toggle()
    }
    
    func addTimer() {
        print("Add Timer Tapped")
    }
    
    func showSettings() {
        viewModel.navigateToSettings.toggle()
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
