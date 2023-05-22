//
//  LoginView.swift
//  Lets-Connect
//
//  Created by HD-045 on 11/05/23.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State var id: String = ""
    @EnvironmentObject var authViewModel: AuthServiceViewModel
    
    var body: some View {
        
        VStack{
            Spacer()
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName]
            } onCompletion: { result in
                switch result {
                case .success(let auth):
                    if let credentials = auth.credential as? ASAuthorizationAppleIDCredential {
                        do {
                            if let user = try AppleUser(from: credentials) {
                                do {
                                    let userData = try user.encodeToData()
                                    self.id = user.userId
                                    try KeychainWrapper.saveToKeyChain(key: user.userId, data: userData)
                                    authViewModel.setLoggedInStatus(user: user)
                                } catch let saveError {
                                    print("Error saving user data to Keychain: \(saveError)")
                                    // Handle the error appropriately, e.g., display an error message to the user
                                }
                            } else {
                                do {
                                    if let userData = try KeychainWrapper.loadFromKeyChain(key: credentials.user) {
                                        let user = try JSONDecoder().decode(AppleUser.self, from: userData)
                                        authViewModel.setLoggedInStatus(user: user)
                                        self.id = credentials.user
                                    }
                                } catch let loadError {
                                    print("Error loading user data from Keychain: \(loadError)")
                                    // Handle the error appropriately, e.g., display an error message to the user
                                }
                            }
                        } catch let conversionError {
                            print("Error creating AppleUser from credentials: \(conversionError)")
                            // Handle the error appropriately, e.g., display an error message to the user
                        }
                    }

                case .failure(let error):
                    print(error.localizedDescription)
                    // Handle the failure appropriately, e.g., display an error message to the user
                }
            }

            .frame(height:45)
            .padding()
            
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


