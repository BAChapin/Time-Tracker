//
//  FirebaseAuthService.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/8/22.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

enum AuthError: Error {
    case noUser
    case incorrentInformation
    case invalidEmail
    case passwordMismatch
    case weakPassword
    case emailAlreadyUsed
    case unknown
}

class FirebaseAuthService {
    
    @MainActor
    func signIn(_ emailAddress: String, password: String) async -> Result<String, AuthError> {
        do {
            let authData = try await Auth.auth().signIn(withEmail: emailAddress, password: password)
            let user = authData.user
            return .success(user.uid)
        } catch (let error as AuthErrorCode) {
            print(error)
            switch error.code {
            case .wrongPassword:
                return .failure(AuthError.incorrentInformation)
            case .userNotFound:
                return .failure(AuthError.noUser)
            default:
                return .failure(AuthError.unknown)
            }
        } catch {
            return .failure(.unknown)
        }
    }
    
    @MainActor
    func createAccount(with emailAddress: String, password: String) async -> Result<String, AuthError> {
        do {
            let authData = try await Auth.auth().createUser(withEmail: emailAddress, password: password)
            return .success(authData.user.uid)
        } catch (let error as AuthErrorCode) {
            switch error.code {
            case .invalidEmail:
                return .failure(.invalidEmail)
            case .emailAlreadyInUse:
                return .failure(.emailAlreadyUsed)
            case .weakPassword:
                return .failure(.weakPassword)
            default:
                return .failure(.unknown)
            }
        } catch {
            return .failure(.unknown)
        }
    }
    
    func getCurrentUserId() -> String? {
        let user = Auth.auth().currentUser
        return user?.uid
    }
    
    func signOut() throws {
        let firAuth = Auth.auth()
        do {
            try firAuth.signOut()
        } catch {
            throw AuthError.unknown
        }
    }
    
}
