//
//  ProfileFieldsView.swift
//  HydrateMe
//
//  Created by jordan artzy-mccendie on 2025-04-10.
//
import SwiftUI

struct ProfileFieldsView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    var uid: String
    var updateField: (String, String, String) -> Void
    var isValidEmail: (String) -> Bool
    @Binding var isEmailValid: Bool
    @Binding var errorMsg: String
    @Binding var alert: Bool

    var body: some View {
        VStack(alignment: .center) {
            TextField("First Name", text: $firstName)
                .onChange(of: firstName) { newValue in
                    guard !uid.isEmpty else { return }
                    updateField("firstName", newValue, uid)
                }
                .padding()
                .frame(width: 300.0, height: 60.0)
                .background(Color("textboxblue"))
                .cornerRadius(8)

            TextField("Last Name", text: $lastName)
                .onChange(of: lastName) { newValue in
                    guard !uid.isEmpty else { return }
                    updateField("lastName", newValue, uid)
                }
                .padding()
                .frame(width: 300.0, height: 60.0)
                .background(Color("textboxblue"))
                .cornerRadius(8)

            TextField("Email", text: $email)
                .onChange(of: email) { newValue in
                    isEmailValid = isValidEmail(newValue)
                    errorMsg = isEmailValid ? "" : "Please enter a valid email address."
                    alert = !isEmailValid
                    if isEmailValid && !uid.isEmpty {
                        updateField("email", newValue, uid)
                    }
                }
                .padding()
                .frame(width: 300.0, height: 60.0)
                .background(Color("textboxblue"))
                .cornerRadius(8)
        }
    }
}
