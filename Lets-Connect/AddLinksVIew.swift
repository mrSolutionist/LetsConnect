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
    
//    var modifiedURL : String {
//        return addHTTPSPrefix(to: url)
//    }
    
    func modifiedURL(platform: SocialMediaPlatform) -> String {
        var modifiedURL = url
        
        if platform == .Whatsapp {
            modifiedURL = "https://api.whatsapp.com/send/?phone=\(modifiedURL)&text&type=phone_number&app_absent=0"
        } else {
            modifiedURL =  addHTTPSPrefix(to: url)
        }
        
        return modifiedURL
    }
    
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
                    userViewModel.dismissKeyboard()
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
                
                VStack {
                    if url.isEmpty {
                        Button(action: {
                            if let content = UIPasteboard.general.string {
                                url = content
                            }
                            if url.isEmpty {
                                showAlert.toggle()
                            }
                        }) {
                            HStack {
                                Label("Paste", systemImage: "doc.on.clipboard")
                                
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: 140, maxHeight: 40)
                            .buttonStyle(.bordered)
                            .background(Color("Black"))
                            .foregroundColor(Color("Secondary"))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("Secondary"), lineWidth: 2)
                            )
                        }
                    } else {
                        Button(action: {
                            // Updating Profile
                            if let oldProfile = userViewModel.profileSelectedForUpdate {
                                userViewModel.updateSocialProfile(platform: platforms[activeIndex], url: modifiedURL(platform: platforms[activeIndex]), oldProfile: oldProfile)
                            } else {
                                // Creating new Profile
                                userViewModel.addSocialProfile(platform: platforms[activeIndex], url: modifiedURL(platform: platforms[activeIndex]))
                            }
                            url.removeAll()
                            userViewModel.addProfile.toggle()
                            userViewModel.dismissKeyboard()
                        }) {
                            Text("Done")
                                .fontWeight(.regular)
                                .font(.headline)
                                .padding(.horizontal)
                                .frame(maxWidth: 140, maxHeight: 40)
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
                }


                
                
                
                
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
    
   private func addHTTPSPrefix(to urlString: String) -> String {
        var modifiedURLString = urlString
        if !modifiedURLString.hasPrefix("https://") && !modifiedURLString.hasPrefix("http://") {
            modifiedURLString = "https://" + modifiedURLString
        }
        return modifiedURLString
    }

}

struct AddLinksView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AddLinksView(userViewModel: UserProfileViewModel())
            
            
            
        }
        
    }
}
