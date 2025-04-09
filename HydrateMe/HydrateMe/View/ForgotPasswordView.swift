//
//  ForgotPasswordView.swift
//  HydrateMe
//
//  Created by english on 2025-03-20.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var conPassword = ""
    @State private var password = ""
    @State private var email = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var isEmailValid = true
    @State private var isPasswordValid = true
    @State private var alert = false
    @State private var errorMsg = ""
    @State private var matchingPsw = false
    
    @State private var navigateToLogin = false
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 45)
                    .padding(.bottom, -24.0)
                    .foregroundColor(Color("login"))
                    .frame(width: 380.0, height: 770.0)
                    .overlay(
                        VStack{
                            Text("Forgot Password")
                                .font(.lifeSaver)
                                .fontWeight(.bold)
                                .padding(.top, 40.0)
                                .foregroundColor(Color("textcolor"))
                            
                            Spacer()
                            VStack(alignment: .center){
                                HStack{
                                    Text("Search User")
                                        .foregroundColor(Color("anotherblue 1"))
                                    Spacer()
                                        .frame(width: 200.0)
                                }
                                
                                TextField("Email", text: $email)
                                    .onChange(of: email) { newValue in
                                        isEmailValid = isValidEmail(newValue)
                                        errorMsg = isEmailValid ? "" : "Please enter a valid email address."
                                        alert = !isEmailValid
                                    }
                                    .padding()
                                    .frame(width: 300.0, height: 60.0)
                                    .background(Color("textboxblue"))
                                    .cornerRadius(8)
                            }
                            VStack(alignment: .center) {
                                HStack{
                                    Text("Create a password")
                                        .foregroundColor(Color("anotherblue 1"))
                                    Spacer()
                                        .frame(width: 150.0)
                                }
                                //CSS
                                SecureField("Password", text: $password)
                                    .onChange(of: password) { newValue in
                                        isPasswordValid = isValidPassword(newValue)
                                        alert = !isPasswordValid
                                    }
                                    .padding()
                                    .frame(width: 300.0, height: 60.0)
                                    .background(Color("textboxblue"))
                                    .cornerRadius(8)
                                
                                SecureField("Confirm Password", text: $conPassword)
                                    .onChange(of: conPassword) { newValue in
                                        matchingPsw = isSimilarPsw(password,newValue)
                                        if !matchingPsw {
                                            errorMsg = "Password does not match"
                                        } else {
                                            errorMsg = ""
                                        }
                                    }
                                    .padding()
                                    .frame(width: 300.0, height: 60.0)
                                    .background(Color("textboxblue"))
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("• at least 1 uppercase letter")
                                        .foregroundColor(.white)
                                    Text("and 1 lowercase letter.")
                                        .padding(.leading, 11.0)
                                        .foregroundColor(.white)
                                    Text("• at least 8 characters required.")
                                        .foregroundColor(.white)
                                    Text("• numbers and letters required.")
                                        .foregroundColor(.white)
                                }
                                //CSS
                            }
                            Spacer()
                            Button(action: {
                                if matchingPsw && isEmailValid && isPasswordValid {
                                    FirebaseModel.shared.singUp(email: email, password: password) { result in
                                        switch result {
                                        case .success(let user):
                                            print("User signed up: \(user.email ?? "")")
                                            errorMsg = ""
                                            navigateToLogin = true
                                        case .failure(let error):
                                            errorMsg = error.localizedDescription
                                        }
                                    }
                                } else {
                                    errorMsg = "Please check your email, password, and confirmation password."
                                }
                            }) {
                                Image("water 2")
                                    .resizable()
                                    .frame(width: 79, height: 79)
                                // CSS
                            }
                            .padding(.bottom, 20.0)

                            NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                                EmptyView()
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
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
    
    private func getPasswordValidationError(_ password: String) -> String {
        let minLength = 8
        var errorMsg = ""
        
        if password.count < minLength {
            errorMsg += "Password must be at least \(minLength) characters long."
        }
        if !NSPredicate(format: "SELF MATCHES %@", "(?=.*[a-z])").evaluate(with: password) {
            errorMsg += "\nPassword must contain at least one lower case letter."
        }
        if !NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])").evaluate(with: password) {
            errorMsg += "\nPassword must contain at least one upper case letter."
        }
        if !NSPredicate(format: "SELF MATCHES %@", "(?=.*\\d)").evaluate(with: password) {
            errorMsg += "\nPassword must contain at least one digit."
        }
        
        return errorMsg
    }
    
    public func isValidPassword(_ password: String) -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }
    
    public func isSimilarPsw(_ password: String,_ conPassword: String) -> Bool {
        return password == conPassword
    }
}

#Preview {
    ForgotPasswordView()
}
