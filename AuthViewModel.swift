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
    static var loggedUserDetails: LoggedUserDetails?

    private var cancellables: Set<AnyCancellable> = []

    init() {
        loadUserFromUserDefaults()
        subscribeToCoreDataChanges()
    }

    func setLoggedInStatus() {
        AuthServiceViewModel.loggedUserDetails?.isLoggedIn = true
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }

    func setLoggedOutStatus() {
        AuthServiceViewModel.loggedUserDetails = nil
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }

    private func loadUserFromUserDefaults() {
        guard let userId = UserDefaults.standard.string(forKey: "currentUser"),
              UserDefaults.standard.bool(forKey: "isLoggedIn") else {
            return
        }

        if let currentUser = DataModel.shared.fetchUserFromCoreData(userId: userId) {
            AuthServiceViewModel.loggedUserDetails = LoggedUserDetails(user: currentUser)
        }
    }

    private func subscribeToCoreDataChanges() {
        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange)
            .sink { [weak self] _ in
                self?.handleCoreDataChanges()
            }
            .store(in: &cancellables)
    }

    private func handleCoreDataChanges() {
        guard let userId = UserDefaults.standard.string(forKey: "currentUser") else {
            return
        }

        if let currentUser = DataModel.shared.fetchUserFromCoreData(userId: userId) {
            AuthServiceViewModel.loggedUserDetails = LoggedUserDetails(user: currentUser)
        }
    }
}
