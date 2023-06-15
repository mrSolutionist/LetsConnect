//
//  NavigationViewModel.swift
//  Lets-Connect
//
//  Created by HD-045 on 15/06/23.
//

import Foundation


class NavigationRouteViewModel: ObservableObject{
   
    @Published var navigationPath: [Route] = [Route]()
    
    func pushView(route: Route) {
        if navigationPath.last != route {
            navigationPath.append(route)
        }
    }
    
    func popView() {
        if navigationPath.isEmpty == false {
            navigationPath.removeLast()
        }
    }
    
    func popToRootView() {
        navigationPath = .init()
    }
    
    func popToSpecificView(k: Int) {
        if navigationPath.isEmpty == false {
            navigationPath.removeLast(k)
        }
    }
    
    func setRootView(route: Route) {
        if navigationPath.isEmpty == false {
            navigationPath.removeLast(navigationPath.count)
            navigationPath.append(route)
        }
    }
    
    enum Route: Hashable {
    
        case Profile
    }



}
