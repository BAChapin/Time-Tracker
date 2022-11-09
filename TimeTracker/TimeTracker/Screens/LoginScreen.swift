//
//  LoginScreen.swift
//  TimeTracker
//
//  Created by Brett Chapin on 11/6/22.
//

import SwiftUI

struct LoginScreen: View {
    
    @ObservedObject var viewModel = LoginViewModel()
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "clock.badge.checkmark.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.green, .black)
                .font(.system(size: 150))
                .padding(.bottom, 75)
                .padding(.top, 100)
            
            Text(viewModel.errorMessage)
                .font(.caption)
                .foregroundColor(.red)
            
            TextField("UsernameLabel", text: $email, prompt: Text("Username"))
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .roundedBorder(height: 45)
            
            SecureField("PasswordLabel", text: $password, prompt: Text("Password"))
                .roundedBorder(height: 45)
            
            HStack {
                Spacer()
                
                Button {
                    print("Forgot Password Tapped")
                } label: {
                    Text("Forgot your password?")
                }
            }
            
            HStack {
                Button {
                    print("Create Account Tapped")
                } label: {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .frame(height: 25)
                }
                .buttonStyle(.bordered)
                
                Button {
                    Task {
                        await viewModel.signIn(email, password: password)
                    }
                } label: {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .frame(height: 25)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.top, 20)
            
            Spacer()
            
        }
        .padding(.horizontal)
        .ignoresSafeArea()
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
