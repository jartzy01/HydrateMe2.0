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
                .font(.lifeSaverbold)
                .padding(.top, 11.0)
                .foregroundColor(Color("titleblue"))
            HStack{
                Spacer()
                Text("Powered by")
                    .foregroundColor(Color("titleblue"))
                    .font(.system(size: 14))
                Text("H2O")
                    .font(.chelaone)
                    .foregroundColor(Color("titleblue"))
                Spacer()
                    .frame(width: 40.0)
            }
            .padding(.top, -45.0)
            Spacer()
            RoundedRectangle(cornerRadius: 40)
                .padding(.bottom, -34.0)
                .foregroundColor(Color("login"))
                .frame(height: 440.0)
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(.all)
                .overlay(
                    VStack(alignment: .center){
                        Text("Login")
                            .font(.lifeSaver)
                            .fontWeight(.bold)
                            .padding(.top, 40.0)
                            .foregroundColor(Color("textcolor"))
                        Spacer()
                            .frame(height: 34.0)
                        TextField("Email", text: $email)
                            .padding()
                            .frame(width: 300.0, height: 60.0)
                            .background(Color("textboxblue"))
                            .cornerRadius(8)
                        Spacer()
                            .frame(height: 18.0)
                        TextField("Password", text: $password)
                            .padding()
                            .frame(width: 300.0, height: 60.0)
                            .background(Color("textboxblue"))
                            .foregroundStyle(Color("textcolor"))
                            .cornerRadius(8)
                        Spacer()
                            .frame(height: 18.0)
                        NavigationLink(destination: ForgotPasswordView()){
                            HStack{
                                Text("Forgot Password?")
                                    .font(.system(size: 17))
                                    .foregroundStyle(Color("textcolor"))
                                    .padding(.leading, 75.0)
                                Spacer()
                            }
                        }
                        Spacer()
                            .frame(height: 30.0)
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
                            Image("water 2")
                                .resizable()
                                .frame(width: 79, height: 79)
                        }
                        Spacer()
                            .frame(height: 30.0)
                        HStack{
                            Text("Don't have an account?")
                                .font(.system(size: 17))
                                .foregroundStyle(Color("anotherblue"))
                            NavigationLink(destination: SignUpView()){
                                Text("Sign Up")
                                    .font(.system(size: 17))
                                    .foregroundStyle(Color("textcolor"))
                            }
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
