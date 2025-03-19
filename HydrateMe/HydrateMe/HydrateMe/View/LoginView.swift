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
//                .font(.system(size: 70, weight: .bold, design: Font.Design?))
                //.f
            
            TextField("Email", text: $email)
                //CSS
            SecureField("Password", text: $password)
                //CSS
            
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
        .background(
            Image("underwater")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
    }
    
//    private func isValidEmail(_ email: String) -> Bool {
//        let regex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
//        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", regex)
//        return predicate.evaluate(with: email)
//    }
//    
//    private func getPasswordValidationError(_ password: String) -> String {
//        let minLength = 8
//        var errorMsg = ""
//        
//        if password.count < minLength {
//            errorMsg += "Password must be at least \(minLength) characters long."
//        }
//        if !NSPredicate(format: "SELF MATCHES %@", "(?=.*[a-z])").evaluate(with: password) {
//            errorMsg += "\nPassword must contain at least one lower case letter."
//        }
//        if !NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])").evaluate(with: password) {
//            errorMsg += "\nPassword must contain at least one upper case letter."
//        }
//        if !NSPredicate(format: "SELF MATCHES %@", "(?=.*\\d)").evaluate(with: password) {
//            errorMsg += "\nPassword must contain at least one digit."
//        }
//        
//        return errorMsg
//    }
//    
//    public func isValidPassword(_ password: String) -> Bool {
//        let minLenght = 8
//        let regexLower = "(?=.*[a-z])"
//        let regexUpper = "(?=.*[A-Z])"
//        let regexDigit = "(?=.*\\d)"
//        
//        let predicateL = NSPredicate(format: "SELF MATCHES[c] %@", regexLower)
//        let predicateU = NSPredicate(format: "SELF MATCHES[c] %@", regexUpper)
//        let predicateD = NSPredicate(format: "SELF MATCHES[c] %@", regexDigit)
//        
//        return password.count >= minLenght &&
//        predicateD.evaluate(with: password) &&
//        predicateL.evaluate(with: password) &&
//        predicateU.evaluate(with: password)
//    }
}

#Preview {
    LoginView()
}
