//
//  SettingsScreen.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/14/22.
//

import SwiftUI

struct SettingsScreen: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var environment: TimeEnvironment
    
    var body: some View {
        Form {
            Section {
                Button("Sign Out") {
                    dismiss()
                    environment.signOut()
                }
                
                Button("Delete Account") {
                    print("Delete Account Tapped")
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
