//
//  AuthViewModel.swift
//  Lets-Connect
//
//  Created by HD-045 on 16/05/23.
//

import Foundation
import SwiftUI

class AuthServiceViewModel: ObservableObject{
   
    @Published var loggedUserDetails: LoggedUserDetails?
  
    init(){
        loadUserFromUserDefaults()
    }
    
    // Set to static to easily access anywhere without passing the object
    func setLoggedInStatus(user : AppleUser) {
        loggedUserDetails?.isLoggedIn = true
       UserDefaults.standard.set(true, forKey: "isLoggedIn")
      
    }
    
    // Set to static to easily access anywhere without passing the object
    func setLoggedOutStatus() {
        loggedUserDetails?.isLoggedIn = false
        // Set the login status to false in UserDefaults
       UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
    private func loadUserFromUserDefaults() {
        loggedUserDetails?.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
      }
    
    
 
    
  
}

