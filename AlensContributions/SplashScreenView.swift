//
//  SplashScreenView.swift
//  Lets-Connect
//
//  Created by Apple  on 29/05/23.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack{
            Color("Primary")
                .ignoresSafeArea()
            
            Text("Let's Connect 🫠")
                .fontWeight(.regular)
                .font(.largeTitle)
                .foregroundColor(Color("Secondary"))
        }
            
            
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
