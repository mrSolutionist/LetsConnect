//
//  LoginView.swift
//  Lets-Connect
//
//  Created by HD-045 on 11/05/23.
//

import SwiftUI
import AuthenticationServices
import Lottie

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthServiceViewModel
    @State private var showAlert = false
    @State var animation: LottieAnimationView?
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
          
            AnimationViewLottie(lottiefile: "HomeAnimation")
                
            
            Spacer()
            
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName]
            } onCompletion: { result in
                switch result {
                case .success(let auth):
                    if let credentials = auth.credential as? ASAuthorizationAppleIDCredential {
                        do {
                            
                            
                            if let user = try AppleUser(from: credentials) {
                                // creating user
                                authViewModel.loggedUserDetails = LoggedUserDetails(user: user)
                                
                                let userData = try user.encodeToData()
                                // Saving to keyChain
                                try KeychainWrapper.saveToKeyChain(key: user.userId, data: userData)
                                
                            } else {
                                // Retrieving from KeyChain
                                if let userData = try KeychainWrapper.loadFromKeyChain(key: credentials.user) {
                                    let user = try JSONDecoder().decode(AppleUser.self, from: userData)
                                    // creating user
                                    authViewModel.loggedUserDetails = LoggedUserDetails(user: user)
                                    
                                }
                            }
                        } catch {
                            authViewModel.setLoggedOutStatus()
                            showAlert = true
#if DEBUG
                            print("Error creating AppleUser from credentials: \(error)")
#endif
                            
                        }
                    }
                case .failure(let error):
#if DEBUG
                    print(error.localizedDescription)
#endif
                    
                    // Handle the failure appropriately, e.g., display an error message to the user
                }
            }
            .frame(height: 45)
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .padding()
            
            Button {
                authViewModel.loggedUserDetails = LoggedUserDetails()
            } label: {
                HStack {
                   Spacer()
                    Image(systemName: "theatermasks.fill")
                    Text("Skip Login")
                        .fontWeight(.heavy)
                        .font(.subheadline)
                    Spacer()
                }
               
            }
            .padding(10)
            .buttonStyle(.borderless)
            .background(colorScheme == .dark ? .white : .black)
            .foregroundColor(colorScheme == .dark ? .black : .white)
            .cornerRadius(5)
            .padding()
           
        }
        .background(.thinMaterial)
        .background(RadialGradient(gradient: Gradient(colors: [Color.blue, Color.white]), center: .center, startRadius: 0, endRadius: 500))
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Keychain Save Error"),
                message: Text("An error occurred while saving user data to the keychain. Please try again."),
                primaryButton: .default(Text("Retry"), action: {
                    // Retry the keychain save operation
                    // You can add any necessary logic here before retrying
                    KeychainWrapper.deleteUserFromKeychain(forKey: authViewModel.loggedUserDetails?.userId ?? "")
                    authViewModel.setLoggedInStatus()
                }),
                secondaryButton: .cancel()
            )
        }
       
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}





struct AppleUser: Codable{
    let userId: String
    let firstName: String
    let lastName: String
    
    init?(from credentials: ASAuthorizationAppleIDCredential) throws {
        guard
            let firstName = credentials.fullName?.givenName,
            let lastName = credentials.fullName?.familyName
        else { return nil }
        
        self.userId = credentials.user
        self.firstName = firstName
        self.lastName = lastName
        
    }
    
    func encodeToData() throws -> Data {
        do {
            let data = try JSONEncoder().encode(self)
            return data
        } catch {
            throw error
        }
    }
}


