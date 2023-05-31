//
//  AppleSignIn.swift
//  Lets-Connect
//
//  Created by Apple  on 31/05/23.
//

import SwiftUI

struct AppleSignInView: View {
    let screeHeight = UIScreen.main.bounds.height
    var body: some View {
        VStack(spacing:0){
            HStack{
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: screeHeight - screeHeight/4)
            .background(Color("Primary"))
            VStack{
                
                Text("LOG IN")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top,60)
                Text("With")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.vertical,2)

                Text("Apple")
                    .frame(maxWidth: .infinity)
                    .font(.body)
                    .padding(9)
                    .overlay(
                        RoundedRectangle(cornerRadius:4)
                        .stroke(lineWidth: 1)

                    )
                    
                    .padding(.vertical,20)
                    .padding(.horizontal,30)
                Spacer()
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: screeHeight - screeHeight/3)
            .foregroundColor(Color.white)
            .background(Color.black.opacity(0.9))
            .overlay(alignment:.top){
                Image(systemName: "apple.logo")
                    .font(.largeTitle)
                       .foregroundColor(.black)
                       .padding()
                       .background(.white)
                       .clipShape(Circle())
                       .offset(y:-30)
            }
        }
    }
}

struct AppleSignIn_Previews: PreviewProvider {
    static var previews: some View {
        AppleSignInView()
    }
}
