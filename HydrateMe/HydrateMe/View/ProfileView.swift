//
//  ProfileView.swift
//  HydrateMe
//
//  Created by english on 2025-03-06.
//

import FirebaseAuth
import SwiftUI

struct ProfileView: View {
    @State private var uid: String = ""
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
    @State private var hydrationGoal = ""
    
    @State var isProfileExpanded: Bool = false
    @State var isPasswordExpanded: Bool = false
    @State var isHydrationExpanded: Bool = false
    @State var isSettingsExpanded: Bool = false
    
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            ProfileContentView(
                uid: $uid,
                firstName: $firstName,
                lastName: $lastName,
                email: $email,
                hydrationGoal: $hydrationGoal,
                isProfileExpanded: $isProfileExpanded,
                isPasswordExpanded: $isPasswordExpanded,
                isHydrationExpanded: $isHydrationExpanded,
                isEmailValid: $isEmailValid,
                alert: $alert,
                errorMsg: $errorMsg,
                password: $password,
                conPassword: $conPassword,
                isPasswordValid: $isPasswordValid,
                matchingPsw: $matchingPsw,
                isValidEmail: isValidEmail,
                isValidPassword: isValidPassword,
                isSimilarPsw: isSimilarPsw,
                viewModel: viewModel
            )



            .background(
                Image("underwater")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            )
            .onAppear {
                if let currentUser = Auth.auth().currentUser {
                    uid = currentUser.uid
                    viewModel.fetchUserInfo(uid: uid)
                } else {
                    errorMsg = "User not logged in"
                    alert = true
                }
            }
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
    ProfileView()
}
