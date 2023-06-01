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
    func setLoggedInStatus() {
        loggedUserDetails?.isLoggedIn = true
       UserDefaults.standard.set(true, forKey: "isLoggedIn")
      
    }
    
    // Set to static to easily access anywhere without passing the object
    func setLoggedOutStatus() {
        loggedUserDetails = nil
        // Set the login status to false in UserDefaults
       UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
    private func loadUserFromUserDefaults()  {
        guard let userId = UserDefaults.standard.string(forKey: "currentUser"),
              UserDefaults.standard.bool(forKey: "isLoggedIn") else {
            return
        }
        
        if let currentUser =  DataModel.shared.fetchUserFromCoreData(userId: userId) {
            loggedUserDetails = LoggedUserDetails(user: currentUser)
        }
    }


    
    
  

    
    
  
}

