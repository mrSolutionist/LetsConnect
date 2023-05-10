//
//  Lets_ConnectApp.swift
//  Lets-Connect
//
//  Created by HD-045 on 29/04/23.
//

import SwiftUI

@main
struct Lets_ConnectApp: App {
    let persistenceController = DataModel.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
