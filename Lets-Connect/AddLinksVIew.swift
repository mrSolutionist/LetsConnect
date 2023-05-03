//
//  AddLinksVIew.swift
//  Lets-Connect
//
//  Created by HD-045 on 02/05/23.
//

import SwiftUI

struct AddLinksView: View {
    @ObservedObject var userViewModel: UserProfileViewModel
    @State var showAlert = false
    @State var activeIndex = 0
    let platforms: [SocialMediaPlatform] = [.Instagram, .Facebook, .LinkedIn, .Youtube, .Whatsapp, .Twitter, .StackOverFlow, .Other]
    @State var url = ""

    var body: some View {
        VStack(alignment: .leading,spacing: 16) {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(platforms.indices, id: \.self) { index in
                        Button(action: {
                            activeIndex = index
                        }) {
                            ZStack {
                                Circle()
                                    .stroke(activeIndex == index ? Color("Secondary") : Color.clear, lineWidth: 2)
                                    .frame(width: 50, height: 50)
                                Image(platforms[index].rawValue)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 48, height: 48)
                            }
                        }
                    }
                }
            }
            
            Text("Link")
                .foregroundColor(Color("Secondary"))
                .fontWeight(.bold)
            
            TextField("Paste Link here", text: $url)
                .foregroundColor(Color("Secondary"))
                .frame(height: 50)
                .background(Color("Primary"))
                .cornerRadius(10)
                .accentColor(Color("Secondary"))
            
            HStack {
                Spacer()
                Button(action: {
                    if let content = UIPasteboard.general.string {
                        url = content
                    }
                    if url.isEmpty {
                        showAlert.toggle()
                    } else {
                        userViewModel.addSocialProfile(platform: platforms[activeIndex], url: url)
                        userViewModel.addProfile.toggle()
                    }
                    url.removeAll()
                }) {
                    HStack {
                        
                        if url.isEmpty {
                            Label("Paste", systemImage: "doc.on.clipboard")
                        } else {
                            Text("Done")
                                .fontWeight(.heavy)
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: 140, maxHeight: 40)
                }
                .buttonStyle(.bordered)
                .background(Color("Black"))
                .foregroundColor(Color("Secondary"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Secondary"), lineWidth: 2)
            )
                
                Spacer()
            }

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

struct AddLinksView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AddLinksView(userViewModel: UserProfileViewModel())
            
            
            
        }
        
    }
}
