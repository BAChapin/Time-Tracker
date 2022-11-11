//
//  LoginViewModel.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/7/22.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var displayCreateAccount: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: AuthError? = nil
    
    var errorMessage: String {
        if let error {
            switch error {
            case .incorrentInformation:
                return "Email or Password is inaccurate"
            case .noUser:
                return "User account doesn't exist"
            default: return "Encountered an unknown error"
            }
        }
        return ""
    }
    
}
