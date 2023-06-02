//
//  AuthViewModel.swift
//  Lets-Connect
//
//  Created by HD-045 on 16/05/23.
//

import Foundation
import SwiftUI
import Combine

class AuthServiceViewModel: ObservableObject {
    // The currently logged-in user details
    @Published var loggedUserDetails: LoggedUserDetails?

    // Set to static to easily access anywhere without passing the object

    // MARK: - Initialization
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        loadUserFromUserDefaults()
        subscribeToCoreDataChanges()
    }
    
    // MARK: - Public Methods
    
    // Set the login status to true
    func setLoggedInStatus() {
        loggedUserDetails?.isLoggedIn = true
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
    
    // Set the login status to false
    func setLoggedOutStatus() {
        loggedUserDetails = nil
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
    // MARK: - Private Methods
    
    // Load the user details from UserDefaults and update the loggedUserDetails
    private func loadUserFromUserDefaults() {
        guard let userId = UserDefaults.standard.string(forKey: "currentUser"),
              UserDefaults.standard.bool(forKey: "isLoggedIn") else {
            return
        }
        
        if let currentUser = DataModel.shared.fetchUserFromCoreData(userId: userId) {
            loggedUserDetails = LoggedUserDetails(user: currentUser)
        }
    }
    
    // Subscribe to Core Data changes using NotificationCenter
     func subscribeToCoreDataChanges() {
        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange)
            .sink { [weak self] _ in
                self?.handleCoreDataChanges()
            }
            .store(in: &cancellables)
    }
    
    // Handle Core Data changes and update the loggedUserDetails if necessary
    private func handleCoreDataChanges() {
        guard let userId = UserDefaults.standard.string(forKey: "currentUser") else {
            return
        }
        
        if let currentUser = DataModel.shared.fetchUserFromCoreData(userId: userId) {
            loggedUserDetails = LoggedUserDetails(user: currentUser)
        }
    }
}

