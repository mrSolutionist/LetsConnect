//
//  Lets_ConnectApp.swift
//  Lets-Connect
//
//  Created by HD-045 on 29/04/23.
//

import SwiftUI

@main
struct Lets_ConnectApp: App {
   
    @StateObject private var authViewModel = AuthServiceViewModel()
    var body: some Scene {
        WindowGroup {       
            LandingPage()
                .environmentObject(authViewModel)
        }
    }
}
