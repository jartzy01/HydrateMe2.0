//
//  LoginView.swift
//  HydrateMe
//
//  Created by english on 2025-03-06.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var isEmailValid = true
    @State private var isPasswordValid = true
    @State private var isLoggedIn = false
    @State private var errorMsg = ""
    @State private var alert = false
    
    var body: some View {
        VStack(alignment: .center){
            
            Text("HydrateMe")
            RoundedRectangle(cornerRadius: 40)
                .fill(Color(hex:"015089").opacity(50))
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .overlay(
                    VStack(alignment: .center){
                        TextField("Email", text: $email)
                            .padding()
                            .frame(width: 299.0)
                            .background(Color.white) // Add white background
                            .cornerRadius(8) // Optional for rounded edges
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Password", text: $password)
                            .padding()
                            .frame(width: 299.0)
                            .background(Color.white) // Add white background
                            .cornerRadius(8) // Optional for rounded edges
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            if !email.isEmpty && !password.isEmpty && !isPasswordValid && !isEmailValid {
                                FirebaseModel.shared.signIn(email: email, password: password) { result in
                                    switch result {
                                    case .success(let user):
                                        print("User signed in: \(user.email ?? "")")
                                    case .failure(let error):
                                        errorMsg = error.localizedDescription
                                    }
                                }
                            } else {
                                errorMsg = "Please enter both email and password"
                            }
                        }) {
                            Text("Sign In")
                            //CSS
                        }
                    }
                )
        }
        .background(
            Image("underwater")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
    }
}
#Preview {
    LoginView()
}
