//
//  MainView.swift
//  HydrateMe
//
//  Created by english on 2025-03-06.
//

import SwiftUI
import FirebaseFirestore

struct MainView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isEmailValid = true
    @State private var isPasswordValid = true
    @State private var isLoggedIn = false
    @State private var errorMsg = ""
    @State private var alert = false
    
    @StateObject private var currentRecord = HydrationRecord(recordId: UUID().uuidString, date: Date(), amountIntake: 0)
    var body: some View {
        
        VStack(alignment: .center){
            RoundedRectangle(cornerRadius: 40)
                .foregroundColor(Color("navbar-blue"))
                .frame(width: 380.0, height: 450.0
                )
                .overlay(
                    VStack(alignment: .center){
                        Spacer()
                            .frame(height: 200)
                        Text("--")
                            .font(.system(size: 30))
                            .foregroundStyle(Color("textcolor"))
                        Text("/2000")
                            .font(.system(size: 30))
                            .foregroundStyle(Color("textcolor"))
                        Spacer()
                            .frame(height:40)
                        //Buttons
                        HStack{
                            Button(action: {
                                if isPasswordValid && isEmailValid {
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
                                RoundedRectangle(cornerRadius: 40)
                                    .foregroundColor(Color("navbar-blue"))
                                    .frame(width: 220.0, height: 80.0)
                                    .overlay(
                                        VStack{
                                            Text(currentRecord.amountIntake, format: .number)
                                                .font(.system(size: 24))
                                                .foregroundStyle(Color("textcolor"))
                                                
                                        }
                                    )
                            }
                            VStack {
                                // Increase button
                                Button(action: {
                                    currentRecord.amountIntake += 10
                                }) {
                                    Image(systemName: "arrowtriangle.up.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                }

                                // Decrease button
                                Button(action: {
                                    currentRecord.amountIntake = max(0, currentRecord.amountIntake - 10)
                                }) {
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                }
                            }
                            
                        }
                        
                        Spacer()
                    }
                )
                        
                .padding(.top, 40.0)
            Spacer()
                .frame(height: 8.0)
            RoundedRectangle(cornerRadius: 40)
                .foregroundColor(Color("navbar-blue"))
                .frame(width: 380.0, height: 240.0)
                .overlay(
                    ZStack{
                        
                    }
                )
                .padding(.bottom, 70.0)
            
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
    MainView()
}
