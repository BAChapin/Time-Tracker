//
//  TimeTrackerApp.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/6/22.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct TimeTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var environemt: TimeEnvironment = TimeEnvironment()

    var body: some Scene {
        WindowGroup {
            if environemt.isUserSignedIn {
                VStack {
                    Text("You're logged in!")
                    
                    Button("Sign Out") {
                        environemt.signOut()
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                LoginScreen()
                    .environmentObject(environemt)
            }
                
        }
    }
}
