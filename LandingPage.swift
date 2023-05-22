//
//  LandingPage.swift
//  Lets-Connect
//
//  Created by HD-045 on 16/05/23.
//

import SwiftUI

struct LandingPage: View {
    let persistenceController = DataModel.shared
    @EnvironmentObject var authViewModel: AuthServiceViewModel
    
   
    var body: some View {
        NavigationStack {
            VStack{
                if authViewModel.isLoggedIn {
                    ContentView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                } else {
                    LoginView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
                
                
            }
        }
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
            .environmentObject(AuthServiceViewModel())
    }
}
