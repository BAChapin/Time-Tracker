//
//  CreateAccountViewModel.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/8/22.
//

import SwiftUI

class CreateAccountViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var error: AuthError? = nil
    
    var errorMessage: String {
        if let error {
            switch error {
            case .invalidEmail:
                return "Email is invalid"
            case .passwordMismatch:
                return "Input passwords don't match"
            case .emailAlreadyUsed:
                return "Account already exists"
            case .weakPassword:
                return "Password is too weak"
            default: return "Encountered an unknown error"
            }
        }
        return ""
    }
    
    var passwordsMatch: Bool {
        return self.validate()
    }
    
    private func validate() -> Bool {
        return confirmPassword.elementsEqual(password)
    }
}
