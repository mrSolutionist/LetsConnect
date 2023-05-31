//
//  File.swift
//  Lets-Connect
//
//  Created by HD-045 on 31/05/23.
//

import Foundation

struct LoggedUserDetails{
    
    
    var firstName: String? 
    var lastName: String?
    var isLoggedIn: Bool?
    
    init(user: AppleUser){
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.isLoggedIn =  true
        
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
         // Save the user's name to UserDefaults
         UserDefaults.standard.set(user.firstName, forKey: "firstName")
         UserDefaults.standard.set(user.lastName, forKey: "lastName")
    }
 
}
