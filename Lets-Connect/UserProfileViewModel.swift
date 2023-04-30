//
//  UserProfileViewModel.swift
//  LetsConnect
//
//  Created by HD-045 on 28/04/23.
//

import Foundation


class UserProfileViewModel:ObservableObject{
    
    @Published var socialProfiles: [SocialMediaProfile] = [SocialMediaProfile(profileImageName: "test_image_1", socialMediaIcon: "test_image_1", profileURL: nil, platform: "Instagram"),
                                                           SocialMediaProfile(profileImageName: "test_image_1", socialMediaIcon: "test_image_1", profileURL: nil, platform: "LinkedIn"),]
    
    func addSocialProfile(profileImageName: String, socialMediaIcon: String, platform: String, url: String) {
        let newProfile = SocialMediaProfile(profileImageName: profileImageName, socialMediaIcon: socialMediaIcon, profileURL: url, platform: platform)
        socialProfiles.append(newProfile)
    }
    
    func updateSocialProfile(at index: Int, platform: String, url: String,profileImageName: String, socialMediaIcon: String) {
        let updatedProfile = SocialMediaProfile(profileImageName: profileImageName, socialMediaIcon: socialMediaIcon, profileURL: url, platform: platform)
        socialProfiles[index] = updatedProfile
    }
    
    func deleteSocialProfile(at index: Int) {
        socialProfiles.remove(at: index)
        
    }
}
