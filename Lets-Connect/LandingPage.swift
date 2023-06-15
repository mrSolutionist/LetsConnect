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
    @StateObject var navigationRoute: NavigationRouteViewModel = NavigationRouteViewModel()
    @StateObject var userViewModel: UserProfileViewModel = UserProfileViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationRoute.navigationPath) {
            VStack {
                if authViewModel.loggedUserDetails?.isLoggedIn == true {
                    ContentView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(userViewModel)
                        .environmentObject(navigationRoute)
                        .navigationBarBackButtonHidden()
                } else {
                    LoginView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .navigationBarBackButtonHidden()
                }
            }
            .navigationDestination(for: NavigationRouteViewModel.Route.self) { view in
                switch view {
                case .Profile:
                    UserProfileView()
                        .environmentObject(userViewModel)
                        .environmentObject(navigationRoute)
                }
            }
        }
        .onChange(of: authViewModel.loggedUserDetails?.isLoggedIn) { isLoggedIn in
            if authViewModel.loggedUserDetails?.isLoggedIn == nil {
                userViewModel.reset()
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
