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
    
            VStack(spacing:20) {
                
                VStack(spacing:10){
                    Image(systemName: "checkmark.circle")
                        .fontWeight(.thin)
                    
                    Text("Received")
                        .fontWeight(.regular)
                    Text("You have received the Profile")
                        .font(.callout)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .font(.title)
                .foregroundColor(.green)
                .background(Color("Black"))
                .cornerRadius(10)
                

                Button(action: {
                    
                }) {
                    HStack {
                        
                      Text("Open in App")
                    }
                    .padding(.horizontal)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 56)
                .background(Color("Primary"))
                .foregroundColor(Color("Secondary"))
                .buttonStyle(.plain)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("#8C8C8C"), lineWidth: 2)
            )
            }
        
       

        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(30)
        .padding(32)
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
