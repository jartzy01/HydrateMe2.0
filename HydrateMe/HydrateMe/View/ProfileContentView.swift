import SwiftUI

struct ProfileContentView: View {
    @Binding var uid: String
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var hydrationGoal: String
    @Binding var isProfileExpanded: Bool
    @Binding var isPasswordExpanded: Bool
    @Binding var isHydrationExpanded: Bool
    @Binding var isEmailValid: Bool
    @Binding var alert: Bool
    @Binding var errorMsg: String
    @Binding var password: String
    @Binding var conPassword: String
    @Binding var isPasswordValid: Bool
    @Binding var matchingPsw: Bool
    var isValidEmail: (String) -> Bool
    var isValidPassword: (String) -> Bool
    var isSimilarPsw: (String, String) -> Bool
    var viewModel: ProfileViewModel

    var body: some View {
        VStack(alignment: .center){
            RoundedRectangle(cornerRadius: 40)
                .foregroundColor(Color("navbar-blue"))
                .frame(width: 380.0, height: 450.0)
                .overlay(
                    VStack {
                        ScrollView {
                            VStack {
                                DisclosureGroup("Profile", isExpanded: $isProfileExpanded) {
                                    ProfileFieldsView(
                                        firstName: $firstName,
                                        lastName: $lastName,
                                        email: $email,
                                        uid: uid,
                                        updateField: viewModel.updateField,
                                        isValidEmail: isValidEmail,
                                        isEmailValid: $isEmailValid,
                                        errorMsg: $errorMsg,
                                        alert: $alert
                                    )
                                    .padding(.leading)
                                }
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.black)
                                .frame(maxWidth: 350)

                                Divider()
                                
                                DisclosureGroup("Change Password", isExpanded: $isPasswordExpanded) {
                                    VStack(alignment: .leading) {
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
                                                matchingPsw = isSimilarPsw(password, newValue)
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
                                            Text("  and 1 lowercase letter.")
                                                .padding(.leading, 11.0)
                                            Text("• at least 8 characters required.")
                                            Text("• numbers and letters required.")
                                        }
                                        .foregroundColor(.white)
                                    }
                                    .padding(.leading)
                                }
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.black)
                                .frame(maxWidth: 350)
                                
                                Divider()
                                
                                DisclosureGroup("Hydration goal", isExpanded: $isHydrationExpanded) {
                                    VStack(alignment: .leading) {
                                        TextField("e.g. 2000 ml", text: $hydrationGoal)
                                            .keyboardType(.numberPad)
                                            .onChange(of: hydrationGoal) { newValue in
                                                guard !newValue.isEmpty, let goal = Double(newValue), !uid.isEmpty else {
                                                    return
                                                }
                                                viewModel.updateField("hydrationGoal", value: goal, uid: uid)
                                            }
                                    }
                                    .padding(.leading)
                                }
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.black)
                                .frame(maxWidth: 350)
                            }
                            .padding(.top, 40.0)
                        }
                    }
                )
                .padding(.top, 40.0)

            Spacer().frame(height: 8.0)

            RoundedRectangle(cornerRadius: 40)
                .foregroundColor(Color("navbar-blue"))
                .frame(width: 380.0, height: 240.0)
                .overlay(
                    VStack {
                        Text("Notifications")
                        Divider()
                        ScrollView { }
                    }
                )
                .padding(.bottom, 70.0)
        }
    }
}
