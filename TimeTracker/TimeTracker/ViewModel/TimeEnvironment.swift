//
//  TimeEnvironment.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/7/22.
//

import SwiftUI

class TimeEnvironment: ObservableObject {
    // User Object
    @Published var userId: String? = nil
    
    var isUserSignedIn: Bool {
        return userId != nil
    }
    
    init() {
        let service = FirebaseAuthService()
        userId = service.getCurrentUserId()
    }
    
    @MainActor
    func signIn(_ email: String, password: String, _ handleError: (AuthError) -> Void) async {
        let service = FirebaseAuthService()
        let response = await service.signIn(email, password: password)
        
        switch response {
        case .success(let id):
            self.userId = id
        case .failure(let error):
            handleError(error)
        }
    }
    
    @MainActor
    func createAccount(_ email: String, password: String, confirmPassword: String, _ handleError: (AuthError) -> Void) async {
        let service = FirebaseAuthService()
        let response = await service.createAccount(with: email, password: password)
        
        switch response {
        case .success(let id):
            self.userId = id
        case .failure(let error):
            handleError(error)
        }
    }
    
    func signOut() {
        let service = FirebaseAuthService()
        do {
            try service.signOut()
            self.userId = nil
        } catch (let error) {
            print(error)
        }
    }
}
