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
                                    .opacity(activeIndex == index ? 1 : 0.3)
                                    .padding(.vertical)
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
                .onSubmit {
                                   UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                               }
                .onAppear {
                    if let profile = userViewModel.profileSelectedForUpdate {
                        url = profile.profileURL!
                        if let platform = SocialMediaPlatform(rawValue: "Instagram") {
                            // platform is .Instagram
                            activeIndex = platforms.firstIndex(of: platform) ?? 0
                        } else {
                            // the string does not match any of the enum cases
                        }
                       
                    }
                }
            
            HStack {
                Button(action: {
                    userViewModel.addProfile.toggle()
                    url.removeAll()
                }) {
                    HStack {
                        Text("Dismiss")
                            .fontWeight(.regular)
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: 140, maxHeight: 40)
                }
                .buttonStyle(.bordered)
                .background(Color("Secondary"))
                .foregroundColor(Color("Primary"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Secondary"), lineWidth: 2)
                )
                
                Spacer()
                
                Button(action: {
                    if let content = UIPasteboard.general.string {
                        url = content
                    }
                    if url.isEmpty {
                        showAlert.toggle()
                    } else {
                        if let oldProfile = userViewModel.profileSelectedForUpdate {
                            userViewModel.updateSocialProfile(platform: platforms[activeIndex], url: url, oldProfile: oldProfile)
                        } else {
                            userViewModel.addSocialProfile(platform: platforms[activeIndex], url: url)
                        }
                        userViewModel.addProfile.toggle()
                    }
                    url.removeAll()
                }) {
                    HStack {
                        
                        if url.isEmpty {
                            Label("Paste", systemImage: "doc.on.clipboard")
                        } else {
                            Text("Done")
                                .fontWeight(.regular)
                                .font(.headline)
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
