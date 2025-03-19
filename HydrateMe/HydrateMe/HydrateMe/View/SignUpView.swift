//
//  SignUpView.swift
//  HydrateMe
//
//  Created by english on 2025-03-12.
//

import SwiftUI

struct SignUpView: View {
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

    var body: some View {
        VStack(alignment: .center){
            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
            
            TextField("Email", text: $email)
                .onChange(of: email) { newValue in
                    isEmailValid = isValidEmail(newValue)
                    errorMsg = isEmailValid ? "" : "Please enter a valid email address."
                    alert = !isEmailValid
                }
            
            SecureField("Password", text: $password)
                .onChange(of: password) { newValue in
                    isPasswordValid = isValidPassword(newValue)
                    alert = !isPasswordValid
                }
            
            SecureField("Confirme Password", text: $conPassword)
                .onChange(of: conPassword) { newValue in
                    matchingPsw = isSimilarPsw(password,newValue)
                    if !matchingPsw {
                        errorMsg = "Password does not match"
                    } else {
                        errorMsg = ""
                    }
                }
            
            
            Button(action: {
                if !matchingPsw && !email.isEmpty {
                    print("Password does not match")
                } else {
                    FirebaseModel.shared.singUp(firstName: firstName,lastName: lastName, email: email, password: password) { result in
                        switch result {
                        case .success(let user):
                            print("User signed up: \(user.email ?? "")")
                            errorMsg = ""
                        case .failure(let error):
                            errorMsg = error.localizedDescription
                        }
                    }
                }
            }) {
                Text("Sign Up")
            }
        
        }
        .background(
            Image("underwater")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let minLenght = 8
        let regexLower = "(?=.*[a-z])"
        let regexUpper = "(?=.*[A-Z])"
        let regexDigit = "(?=.*\\d)"
        
        let predicateL = NSPredicate(format: "SELF MATCHES[c] %@", regexLower)
        let predicateU = NSPredicate(format: "SELF MATCHES[c] %@", regexUpper)
        let predicateD = NSPredicate(format: "SELF MATCHES[c] %@", regexDigit)
        
        return password.count >= minLenght &&
        predicateD.evaluate(with: password) &&
        predicateL.evaluate(with: password) &&
        predicateU.evaluate(with: password)
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
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
    
    public func isSimilarPsw(_ password: String,_ conPassword: String) -> Bool {
        return password == conPassword
    }
}

#Preview {
    SignUpView()
}
