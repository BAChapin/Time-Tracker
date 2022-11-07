//
//  MainScreen.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/6/22.
//

import SwiftUI

struct MainScreen: View {
    var body: some View {
        NavigationStack {
            Text("Hello, World!")
                .navigationTitle("Time Tracker")
                .toolbar {
                    Button {
                        print("Add Tapped")
                    } label: {
                        Label("Add", systemImage: "plus")
                    }

                }
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
