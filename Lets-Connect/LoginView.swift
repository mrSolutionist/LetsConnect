//
//  LoginView.swift
//  Lets-Connect
//
//  Created by HD-045 on 11/05/23.
//

import SwiftUI
import AuthenticationServices


struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthServiceViewModel
    @State private var showAlert = false

    var body: some View {
        VStack {
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
                                AuthServiceViewModel.loggedUserDetails = LoggedUserDetails(user: user)
                                
                                let userData = try user.encodeToData()
                                // Saving to keyChain
                                try KeychainWrapper.saveToKeyChain(key: user.userId, data: userData)
                                
                            } else {
                                // Retrieving from KeyChain
                                if let userData = try KeychainWrapper.loadFromKeyChain(key: credentials.user) {
                                    let user = try JSONDecoder().decode(AppleUser.self, from: userData)
                                    // creating user
                                    AuthServiceViewModel.loggedUserDetails = LoggedUserDetails(user: user)
                                }
                            }
                        } catch {
                            authViewModel.setLoggedOutStatus()
                            showAlert = true
                            print("Error creating AppleUser from credentials: \(error)")
                        }
                    }
                case .failure(let error):
                    
                    print(error.localizedDescription)
                    // Handle the failure appropriately, e.g., display an error message to the user
                }
            }
            .frame(height: 45)
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Keychain Save Error"),
                message: Text("An error occurred while saving user data to the keychain. Please try again."),
                primaryButton: .default(Text("Retry"), action: {
                    // Retry the keychain save operation
                    // You can add any necessary logic here before retrying
                    KeychainWrapper.deleteKeychainItem(forKey: AuthServiceViewModel.loggedUserDetails?.userId ?? "")
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


