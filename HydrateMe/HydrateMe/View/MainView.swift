//
//  MainView.swift
//  HydrateMe
//
//  Created by english on 2025-03-06.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        
        VStack(alignment: .center){
            RoundedRectangle(cornerRadius: 40)
                .foregroundColor(Color("navbar-blue"))
                .frame(width: 380.0, height: 450.0
                )
                .overlay(
                    ZStack{
                        
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
