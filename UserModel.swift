//
//  File.swift
//  Lets-Connect
//
//  Created by HD-045 on 31/05/23.
//

import Foundation

struct LoggedUserDetails {
    var userId: String?
    var firstName: String?
    var lastName: String?
    var isLoggedIn: Bool?
    var fullName: String? {
        guard let firstName = firstName, let lastName = lastName else {
            return nil
        }
        return [firstName, lastName].compactMap { $0 }.joined(separator: " ")
    }

    init(user: AppleUser) {
        self.userId = user.userId
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.isLoggedIn = true
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.setValue(user.userId, forKey: "currentUser")
        // Saving to CoreData
        DataModel.shared.addUserToCoreData(user: user)
        DataModel.shared.saveContext()
    }

    init(user: UserEntity) {
        self.userId = user.userId
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.isLoggedIn = true
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.setValue(user.userId, forKey: "currentUser")
        
    }
}
