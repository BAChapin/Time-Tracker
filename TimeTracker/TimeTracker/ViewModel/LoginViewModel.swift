//
//  LoginViewModel.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/7/22.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var error: AuthError? = nil
    
    var errorMessage: String {
        if let error {
            switch error  {
            case .incorrentInformation:
                return "Email or Password is inaccurate"
            case .noUser:
                return "User account doesn't exist"
            case .unknown:
                return "Encountered an unknown error"
            }
        }
        return ""
    }
    
    @MainActor
    func signIn(_ email: String, password: String) async {
        let service = FirebaseAuthService()
        self.error = nil
        let response = await service.signIn(email, password: password)
        
        switch response {
        case .success(let user):
            print(user)
        case .failure(let error):
            self.error = error
        }
    }
}
