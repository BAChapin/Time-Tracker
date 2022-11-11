//
//  CreateAccountScreen.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/8/22.
//

import SwiftUI

struct CreateAccountScreen: View {
    
    @EnvironmentObject var environment: TimeEnvironment
    @ObservedObject var viewModel = CreateAccountViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 15) {
            TextField("EmailLabel", text: $viewModel.email, prompt: Text("Email Address"))
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .roundedBorder(height: 45)
            
            SecureField("PasswordLabel", text: $viewModel.password, prompt: Text("Password"))
                .roundedBorder(height: 45)
            
            SecureField("ConfirmPasswordLabel", text: $viewModel.confirmPassword, prompt: Text("Confirm Password"))
                .roundedBorder(height: 45)
                .onChange(of: viewModel.confirmPassword) { newValue in
                    if !viewModel.passwordsMatch {
                        viewModel.error = .passwordMismatch
                    } else {
                        viewModel.error = nil
                    }
                }
            
            Text(viewModel.errorMessage)
                .font(.caption)
                .foregroundColor(.red)
                .padding(.top, 30)
            
            Button {
                Task {
                    viewModel.error = nil
                    await environment.createAccount(viewModel.email, password: viewModel.password, confirmPassword: viewModel.confirmPassword, { error in
                        viewModel.error = error
                    })
                    if viewModel.error == nil {
                        dismiss()
                    }
                }
            } label: {
                Text("Create Account")
                    .frame(maxWidth: .infinity)
                    .frame(height: 25)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 50)
            .disabled(!viewModel.passwordsMatch || viewModel.confirmPassword.isEmpty)
        }
        .padding(.horizontal)
        .ignoresSafeArea()
        
    }
}

struct CreateAccountScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountScreen()
    }
}
