//
//  File.swift
//  Lets-Connect
//
//  Created by HD-045 on 31/05/23.
//

import Foundation
import SwiftUI


struct LoggedUserDetails {
    // User ID
    var userId: String?
    
    // User's first name
    var firstName: String?
    
    // User's last name
    var lastName: String?
    
    // Flag indicating if the user is logged in
    var isLoggedIn: Bool?
    
    // User image data
    var imageData: Data?
    
    // User email
    var email: String?
    
    // User phoneNumber
    var phoneNumber: String?
    
    // User's full name
    var fullName: String? {
        guard let firstName = firstName, let lastName = lastName else {
            return nil
        }
        return [firstName, lastName].compactMap { $0 }.joined(separator: " ")
    }

    // Initialize with AppleUser
    init(user: AppleUser) {
        self.userId = user.userId
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.isLoggedIn = true
        
        // Set login status in UserDefaults
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.setValue(user.userId, forKey: "currentUser")
        
        // Save user to CoreData
        DataModel.shared.addUserToCoreData(user: user)
        DataModel.shared.saveContext()
    }

    // Initialize with UserEntity
    init(user: UserEntity) {
        self.userId = user.userId
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.imageData = user.imageData
        self.email = user.email
        self.phoneNumber = user.phoneNumber
        self.isLoggedIn = true
        
        // Set login status in UserDefaults
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.setValue(user.userId, forKey: "currentUser")
       
    }
    
    // Show the user's image as an Image view
    func showImage() -> Image? {
        if let data = self.imageData ?? (DataModel.shared.fetchUserFromCoreData()?.imageData),
           let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        
        return nil
    }

   
}
