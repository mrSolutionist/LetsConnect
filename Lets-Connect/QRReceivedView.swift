//
//  QRReceivedView.swift
//  Lets-Connect
//
//  Created by HD-045 on 03/05/23.
//

import SwiftUI

struct  QRReceivedView: View {
    @ObservedObject var userViewModel: UserProfileViewModel
    @State var showAlert = false
    @State var activeIndex = 0
    let platforms: [SocialMediaPlatform] = [.Instagram, .Facebook, .LinkedIn, .Youtube, .Whatsapp, .Twitter, .StackOverFlow, .Other]
    @State var url = ""

    var body: some View {
        VStack(alignment: .leading,spacing: 16) {
    
            VStack {
                
                VStack{
                    Image(systemName: "checkmark.circle")
                        .fontWeight(.thin)
                    
                    Text("Received")
                        .fontWeight(.regular)
                    Text("You have received the Profile")
                        .font(.callout)
                        .foregroundColor(.white)
                }
                .font(.title)
               
                .foregroundColor(.green)
                Spacer()
                Button(action: {
                    
                }) {
                    HStack {
                        
                      Text("Open in App")
                    }
                    .padding(.horizontal)
                    .frame( maxHeight: 56)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Secondary"), lineWidth: 2)
            )
                
                Spacer()
            }
            .buttonStyle(.bordered)
            .background(Color("Black"))
            .foregroundColor(Color("Secondary"))
            .cornerRadius(10)
       

        }
        .padding()
        .background(Color("Black"))
        .cornerRadius(30)
        .padding(32)
        .shadow(color: .white, radius: 3)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Nothing to paste"),
                message: Text("Clipboard is empty."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}


struct QRReceivedView_Previews: PreviewProvider {
    static var previews: some View {
        QRReceivedView(userViewModel: UserProfileViewModel())
    }
}
