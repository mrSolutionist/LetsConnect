//
//  UserProfileViewModel.swift
//  LetsConnect
//
//  Created by HD-045 on 28/04/23.
//

import Foundation


class UserProfileViewModel:ObservableObject{
    @Published  var activeProfileIndex: Int = 0
    var selectedProfile: SocialMediaProfile {
        socialProfiles[activeProfileIndex]
    }
    @Published var socialProfiles: [SocialMediaProfile] = [SocialMediaProfile( platform: .Instagram, profileURL: "nil"),
                                                           SocialMediaProfile( platform: .LinkedIn, profileURL: "nil"),]
    func addSocialProfile(platform: SocialMediaPlatform, url: String) {
        let newProfile = SocialMediaProfile(platform: platform, profileURL: url)
        socialProfiles.append(newProfile)
    }
    
    func updateSocialProfile(at index: Int, platform: SocialMediaPlatform, url: String) {
        let updatedProfile = SocialMediaProfile(platform: platform, profileURL: url)
        socialProfiles[index] = updatedProfile
    }
    
    func deleteSocialProfile(at index: Int) {
        socialProfiles.remove(at: index)
        
    }
}
