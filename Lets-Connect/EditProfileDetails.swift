//
//  EditProfileDetails.swift
//  LetsConnect
//
//  Created by HD-045 on 29/04/23.
//

import SwiftUI
import PhotosUI
struct EditProfileDetails: View {
    @ObservedObject var userViewModel: UserProfileViewModel
    var body: some View {
        VStack{
            EditProfileViewPrimarySection(userViewModel: userViewModel)
            EditProfileDetailView(socialMediaProfile: userViewModel.dbDataSocialProfiles)
            EditProfileVIewBottomSection( userViewModel: userViewModel)
            Spacer()
        }
        .background(.black)
        .onDisappear {
            userViewModel.userImageData = AuthServiceViewModel.loggedUserDetails?.imageData
               }
        
    }
}



struct EditProfileViewPrimarySection: View {
    @State private var activeProfileIndex: Int? = 0
    @ObservedObject var userViewModel: UserProfileViewModel
    
    var body: some View {
        HStack {
            Spacer()
            VStack{
                ZStack {
                    
                    Circle()
                        .stroke(Color("Secondary"), lineWidth: 2)
                        .frame(width: 112, height: 112)
                    if let data = userViewModel.userImageData, let uiImage = UIImage(data: data){
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 110,height: 110)
                    }
                    else{
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
              
                  
                  
                    
                }
                .overlay(alignment: .bottomTrailing){
                    
                    PhotosPicker(selection: $userViewModel.pickedImageItem,  matching: .images) {
                        HStack {
                            Image(systemName: "camera")
                                .foregroundColor(Color("Secondary"))
                               
                                .font(.headline)
                                .padding(12)
                        }
                        .background(Color("Primary"))
                        .clipShape(Circle())
                    }
                    
                }
            }
            .padding()
            Spacer()
        }
        .padding()
        .background(Color("Black"))
    }
}



struct EditProfileDetailView: View {
    var socialMediaProfile : [SocialProfiles]
    @State var userName: String = String()
    @State var email: String = String()
    @State var phoneNumber: String = String()
    
    var body: some View {
        
        VStack(alignment: .leading,spacing: 16){
            
                Text("Name")
                    .foregroundColor(Color("Secondary"))
                    .fontWeight(.bold)
                HStack{
                    Spacer()
                    TextField("Name", text: $userName)
                        .foregroundColor(Color("Secondary"))
                    Spacer()
                }
                .frame(height: 50)
                .background(Color("Primary"))
                .cornerRadius(10)
                
            
            Text("E-mail")
                .foregroundColor(Color("Secondary"))
                .fontWeight(.bold)
            HStack{
                Spacer()
                TextField("email", text: $email)
                    .foregroundColor(Color("Secondary"))
                Spacer()
            }
            .frame(height: 50)
            .background(Color("Primary"))
            .cornerRadius(10)
        
            
            Text("Phone Number")
                .foregroundColor(Color("Secondary"))
                .fontWeight(.bold)
            HStack{
                Spacer()
                TextField("Phone Number", text: $phoneNumber)
                    .foregroundColor(Color("Secondary"))
                Spacer()
            }
            .frame(height: 50)
            .background(Color("Primary"))
            .cornerRadius(10)

        }
        .padding()
    }
}


struct EditProfileVIewBottomSection: View {
    @EnvironmentObject  var authViewModel : AuthServiceViewModel
    @ObservedObject var userViewModel: UserProfileViewModel
    @State var isActiveQR: Bool = false
    @State var showQR: Bool = false
    var body: some View {
        
        
        HStack(spacing:40){
            Button{
                DataModel.shared.updateUserEntity(userId: AuthServiceViewModel.loggedUserDetails?.userId ?? "", imageData: userViewModel.userImageData ?? Data() )
                DataModel.shared.saveContext()
            }label: {
                HStack{
                    Text("Save")
                        .fontWeight(.heavy)
                        .font(.subheadline)
                }
                .padding(.horizontal)
                .frame(maxWidth: 140,maxHeight: 40)
              
            }
            .buttonStyle(.bordered)
            .background(Color("Secondary"))
            .foregroundColor(Color("Primary"))
            .cornerRadius(10)
            
            Button{
                userViewModel.userImageData = AuthServiceViewModel.loggedUserDetails?.imageData
            }label: {
                HStack{
                    Text("Cancel")
                        .fontWeight(.heavy)
                        .font(.subheadline)
                }
            
                .padding(.horizontal)
                .frame(maxWidth: 140,maxHeight: 40)
            }
            .buttonStyle(.bordered)
            .background(Color("Primary"))
            .foregroundColor(Color("Secondary"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("Secondary"), lineWidth: 2)
            )
            
        }
        .buttonStyle(.borderedProminent)
        .padding()
        
    }
}


struct EditProfileDetails_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileDetails(userViewModel: UserProfileViewModel())
    }
}
