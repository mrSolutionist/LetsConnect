//
//  UserProfileViewModel.swift
//  LetsConnect
//
//  Created by HD-045 on 28/04/23.
//

import Foundation


class UserProfileViewModel:ObservableObject{
    @Published var receivedProfile: String =  String() {
        didSet {
            DispatchQueue.main.async {
                // Call your view update method here
                self.profileReceivedStatus()
                
            }
           
        }
       
    }

    @Published  var activeProfileIndex: Int = 0
    @Published var addProfile: Bool = false
    @Published var receivedStatus: Bool = false
    var selectedProfile: SocialMediaProfile {
        socialProfiles[activeProfileIndex]
    }
    @Published var socialProfiles: [SocialMediaProfile] = [SocialMediaProfile( platform: .Instagram, profileURL: "https://github.com/mrSolutionist"),
                                                           SocialMediaProfile( platform: .LinkedIn, profileURL: "https://www.linkedin.com/in/robin-george-ks/"),]
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
    
    private func profileReceivedStatus() {
        receivedStatus.toggle()
    }
}
