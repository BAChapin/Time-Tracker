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
                    .navigationTitle("Time Tracker")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                print("Settings Tapped")
                            } label: {
                                Label("Settings", systemImage: "gear")
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                Button("Add Task") {
                                    let newTask = TimerTask(userId: environment.userId!, name: "\(Int.random(in: 0..<1000))")
                                    viewModel.add(newTask)
                                    print("Add Task Tapped")
                                }
                                Button("Add Timer") {
                                    print("Add Timer Tapped")
                                }
                            } label: {
                                Label("Add", systemImage: "plus")
                            }
                        }
                    }
            } else {
                List() {
                    ForEach(viewModel.tasks, id: \.id) { task in
                        render(task: task)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Time Tracker")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            print("Settings Tapped")
                        } label: {
                            Label("Settings", systemImage: "gear")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("Add Task") {
                                let newTask = TimerTask(userId: environment.userId!, name: "\(Int.random(in: 0..<1000))")
                                viewModel.add(newTask)
                                print("Add Task Tapped")
                            }
                            Button("Add Timer") {
                                print("Add Timer Tapped")
                            }
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
            }
            
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.fetchTasks(for: environment.userId!)
        }
    }
    
    func render(task: TimerTask) -> some View {
        HStack {
            Text(task.name)
                .padding(.leading)
            Spacer()
            Image(systemName: "chevron.right")
                .padding(.trailing)
        }
        .padding(.vertical)
        .background(Color.blue.opacity(0.2))
        .cornerRadius(8)
        .onTapGesture {
            print(task.created)
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
