//
//  AuthViewModel.swift
//  Lets-Connect
//
//  Created by HD-045 on 16/05/23.
//

import Foundation
import SwiftUI

class AuthServiceViewModel: ObservableObject{
    @Published var fullName: String?
    @Published var loggedUserDetails: LoggedUserDetails?
    @Published var isLoggedIn: Bool = false {
        didSet{
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        }
    }
    
    init(){
        loadUserFromUserDefaults()
    }
    
    // Set to static to easily access anywhere without passing the object
    func setLoggedInStatus(user : AppleUser) {
        isLoggedIn = true
       UserDefaults.standard.set(true, forKey: "isLoggedIn")
        // Save the user's name to UserDefaults
        UserDefaults.standard.set(user.firstName, forKey: "firstName")
        UserDefaults.standard.set(user.lastName, forKey: "lastName")
      
    }
    
    // Set to static to easily access anywhere without passing the object
    func setLoggedOutStatus() {
        isLoggedIn = false
        // Set the login status to false in UserDefaults
       UserDefaults.standard.set(false, forKey: "isLoggedIn")
        // Remove the user's name from UserDefaults
        UserDefaults.standard.removeObject(forKey: "firstName")
        UserDefaults.standard.removeObject(forKey: "lastName")
      
       
    }
    
    private func loadUserFromUserDefaults() {
          isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
          guard let firstName = UserDefaults.standard.string(forKey: "firstName"),
                let lastName = UserDefaults.standard.string(forKey: "lastName") else {
              fullName = "Unknown"
              return
          }

          fullName = "\(firstName) \(lastName)"
      }
    
    
  
}

