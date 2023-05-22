//
//  ContentView.swift
//  LetsConnect
//
//  Created by HD-045 on 26/04/23.
//

import SwiftUI
import CoreData
import QRScannerViewKit



struct ContentView: View {
    
    
    @State var showQR: Bool = false
    @State var showScanner: Bool = false
    @StateObject var userViewModel: UserProfileViewModel  = UserProfileViewModel()
    
    var addLinksView: some View {
        AddLinksView(userViewModel: userViewModel)
            .offset(y: userViewModel.addProfile ? 0 : UIScreen.main.bounds.height)
            .animation(.spring(response: 0.7, dampingFraction: 0.6), value: userViewModel.addProfile)
    }

    
    var body: some View {
        ZStack {
            VStack {
                HomeViewPrimarySection(userViewModel: userViewModel)
                SocialMediaProfiles(userViewModel: userViewModel)
                
                Spacer()
                HomeVIewBottomSection(showScanner: $showScanner, showQR: $showQR)
            }
            .background(Color("Black"))
            .blur(radius: userViewModel.receivedStatus || showQR || showScanner || userViewModel.addProfile ? 0.7 : 0)
            .overlay(userViewModel.receivedStatus || showQR || showScanner || userViewModel.addProfile ? Color.black.opacity(0.5) : Color.clear)
            .onTapGesture {
                if showQR || userViewModel.receivedStatus || showScanner || userViewModel.addProfile == true {
                    showScanner = false
                    userViewModel.receivedStatus = false
                    userViewModel.addProfile = false
                    showQR = false
                }
                
            }
            
            QRcode(showQR: $showQR)
                .offset(y: showQR ? 0 : UIScreen.main.bounds.height)
                .animation(.spring(response: 0.7, dampingFraction: 0.6), value: showQR)
                .environmentObject(userViewModel)
            
            addLinksView
            
            QRReceivedView(userViewModel: userViewModel)
                .offset(y: userViewModel.receivedStatus ? 0 : UIScreen.main.bounds.height)
                .animation(.spring(response: 0.7, dampingFraction: 0.6), value: userViewModel.receivedStatus)
            
        }
        
        .fullScreenCover(isPresented: $showScanner, content: {
            QRScannerView{
                profile in
                userViewModel.receivedProfile = profile
            }
            
        })
        
        
    }
    
}



struct  HomeViewPrimarySection: View {
    
    @ObservedObject var userViewModel: UserProfileViewModel
    @EnvironmentObject var authViewModel: AuthServiceViewModel
    
    var body: some View {
        VStack{
            HStack{
                ZStack {
                    
                    Circle()
                        .stroke(Color("Secondary"), lineWidth: 2)
                        .frame(width: 112, height: 112)
                    Image((userViewModel.selectedProfile?.profileImageName) ?? "no_User")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                    if ((userViewModel.selectedProfile?.socialMediaIcon) != nil){
                        Image((userViewModel.selectedProfile?.socialMediaIcon)!)
                        
                            .resizable()
                            .scaledToFit()
                        
                            .clipShape(Circle())
                        
                            .frame(width: 48, height: 48)
                            .offset(x: 32, y: 32)
                    }
                   
                }
                
                Spacer()
                
                VStack(alignment: .trailing){
                    
                        NavigationLink(destination: UserProfileView(userViewModel: userViewModel)) {
                            ZStack {
                                Circle()
                                    .stroke(Color("Secondary"), lineWidth: 2)
                                    .frame(width: 48, height: 48)
                                Image("add_User")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 48, height: 48)
                            }
                        }
                       
                        
                    
                    
                    Group {
                        Text(authViewModel.fullName ?? "")
                            .fontWeight(.bold)
                            .font(.headline)
                        Text(userViewModel.selectedProfile?.platform ?? "NO PROFILE")
                            .textCase(.uppercase)
                            .fontWeight(.heavy)
                            .font(.largeTitle)
                    }
                    .foregroundColor(Color("Secondary"))
                    
                }
                
                
            }
        }
        .padding()
        .background(Color("Primary"))
        
    }
}


struct SocialMediaProfiles: View {
    
    
    @ObservedObject var userViewModel: UserProfileViewModel
    @State var confirmDelete:Bool = false
    var body: some View {
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 20) {
                
             
                ForEach(userViewModel.dbDataSocialProfiles.indices, id: \.self) { index in
                    let profile = userViewModel.dbDataSocialProfiles[index]
                    Button{
                        userViewModel.activeProfileIndex = index
                    }label: {
                        ZStack {
                            Circle()
                                .stroke(Color("Secondary"), lineWidth: 2)
                                .frame(width:48, height: 48)
                            if let profileImage = profile.profileImageName{
                                Image(profileImage)
                                    .resizable()
                                    .scaledToFit()
                                    .background(Color("Secondary"))
                                    .clipShape(Circle())
                                    .frame(width: 48, height: 48)
                                Image(profile.socialMediaIcon ?? "")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 24, height: 24)
                                    .offset(x: 12, y: 12)
                            }
                            else{
                                Image(profile.socialMediaIcon ?? "")
                                    .resizable()
                                    .scaledToFit()
                                    .background(Color("Secondary"))
                                    .clipShape(Circle())
                                    .frame(width: 48, height: 48)
                            }
                            
                        }
                    }.contextMenu {
                        Button(action: {
                            // code to handle update option
                            userViewModel.profileSelectedForUpdate = profile
                            userViewModel.addProfile.toggle()
                        }) {
                            Label("Update", systemImage: "pencil")
                        }
                        Button(action: {
                            // code to handle delete option
                            confirmDelete.toggle()
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .alert(isPresented: $confirmDelete) {
                                Alert(title: Text("Are you sure you want to delete this profile?"),
                                      message: Text("This action cannot be undone."),
                                      primaryButton: .destructive(Text("Delete")) {
                                    userViewModel.deleteSocialProfile(for: profile)
                                      },
                                      secondaryButton: .cancel())
                            }
                    
                }
                
                // Add profile Button
                Button{
                    userViewModel.addProfile.toggle()
                }label: {
                    ZStack {
                        Circle()
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background((Color("Secondary")))
                            .clipShape(Circle())
                            .frame(width: 48, height: 48)
                            .foregroundColor(Color("Primary"))
                        
                    }
                }
                
                
                
            }
            
            
        }
        .animation(.easeInOut, value: confirmDelete)
        .padding()
      
    }
}

struct HomeVIewBottomSection: View {
    
    @State var isActiveQR: Bool = false
    @Binding var showScanner: Bool
    @Binding var showQR: Bool
    
    var body: some View {
        
        VStack{
            HStack(spacing:40){
                Button{
                    showScanner.toggle()
                    
                    
                }label: {
                    HStack{
                        Text("QR")
                            .fontWeight(.heavy)
                            .font(.title)
                        Text("SCAN")
                            .fontWeight(.heavy)
                            .font(.subheadline)
                    }
                    
                    
                    .padding(.horizontal)
                }
                .buttonStyle(.bordered)
                .background(Color("Secondary"))
                .foregroundColor(Color("Primary"))
                .cornerRadius(10)
                
                Button{
                    showQR.toggle()
                }label: {
                    HStack{
                        Text("QR")
                            .fontWeight(.heavy)
                            .font(.title)
                        Text("VIEW")
                            .fontWeight(.heavy)
                            .font(.subheadline)
                    }
                    
                    .padding(.horizontal)
                    
                }
                .buttonStyle(.bordered)
                .background(Color("Primary"))
                .foregroundColor(Color("Secondary"))
                .buttonBorderShape(.roundedRectangle)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Secondary"), lineWidth: 2)
                )
                
                
                
                
                
            }
            .buttonStyle(.borderedProminent)
            
            
            HStack(alignment: .center) {
                Spacer()
                Text("QR")
                Toggle(isOn: $isActiveQR) {
                    EmptyView()
                }
                .toggleStyle(SwitchToggleStyle(tint: Color.red))
                .labelsHidden()
                .padding()
                Text("NFC")
                Spacer()
            }
            .foregroundColor(Color("Secondary"))
        }
        .padding()
        .fontWeight(.heavy)
        .background(Color("Primary"))
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ContentView()
                .environmentObject(AuthServiceViewModel())
            
            
        }
        
    }
}

struct QRcode: View {
    @Binding var showQR: Bool
    var body: some View {
        
        VStack{
            HStack {
                Spacer()
                Button{
                    withAnimation {
                        showQR = false
                    }
                    
                    
                }label: {
                    Image(systemName: "x.square.fill")
                        .font(.largeTitle)
                        .foregroundColor(Color("Secondary"))
                }
                .padding(10)
            }
            
            QRcodeView()
                .background(.white)
                .cornerRadius(50)
                .padding(50)
        }
        
        
        
        
        
        
    }
}




struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}


