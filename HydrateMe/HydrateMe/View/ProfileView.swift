//
//  ProfileView.swift
//  HydrateMe
//
//  Created by english on 2025-03-06.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 45)
                    .padding(.bottom, -24.0)
                    .foregroundColor(Color("login"))
                    .frame(width: 380.0, height: 680.0)
                    .overlay(
                        VStack{}
                    )
            }
            .padding(.bottom, 90.0)
            .padding(.top, 30.0)
            .background(
                Image("underwater")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            )
        }

    }
}

#Preview {
    ProfileView()
}
