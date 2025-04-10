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
    @State private var hydrationHistory: [HydrationRecord] = []

    @StateObject private var currentRecord = HydrationRecord(recordId: UUID().uuidString, date: Date(), amountIntake: 0)
    @StateObject private var viewModel = MainViewModel(record: HydrationRecord(recordId: UUID().uuidString, date: Date(), amountIntake: 0))
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
                        Text("\(viewModel.record.amountIntake)")
                            .font(.system(size: 30))
                            .foregroundStyle(Color("textcolor"))
                        Text("/2000")
                            .font(.system(size: 30))
                            .foregroundStyle(Color("textcolor"))
                        Spacer()
                            .frame(height:40)
                        // save button
                        HStack{
                            Button(action: {
                                let newEntry = HydrationRecord(
                                    recordId: UUID().uuidString,
                                    date: Date(),
                                    amountIntake: currentRecord.amountIntake
                                )

                                hydrationHistory.insert(newEntry, at: 0) // Adds new log entry to the top

                                viewModel.record = HydrationRecord(
                                    recordId: viewModel.record.recordId,
                                    date: viewModel.record.date,
                                    amountIntake: viewModel.record.amountIntake + newEntry.amountIntake)
                            }) {
                                RoundedRectangle(cornerRadius: 40)
                                    .foregroundColor(Color("navbar-blue"))
                                    .frame(width: 220.0, height: 80.0)
                                    .overlay(
                                        HStack {
                                            Text(currentRecord.amountIntake, format: .number)
                                                .font(.system(size: 24))
                                                .foregroundStyle(Color("textcolor"))
                                            Text("ml")
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
                    VStack(alignment: .leading) {
                               Text("Hydration History")
                                   .font(.headline)
                                   .foregroundStyle(Color("textcolor"))
                                   .padding(.top, 10)

                               ScrollView {
                                   VStack(alignment: .leading, spacing: 8) {
                                       ForEach(hydrationHistory) { record in
                                           HStack {
                                               Text("+\(Int(record.amountIntake))ml")
                                                   .foregroundColor(Color("textcolor"))
                                               Spacer()
                                               Text(record.date, style: .time)
                                                   .foregroundColor(.gray)
                                                   .font(.caption)
                                           }
                                           .padding(.horizontal)
                                       }
                                   }
                               }
                               .padding(.bottom, 10)
                           }
                           .padding()
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
