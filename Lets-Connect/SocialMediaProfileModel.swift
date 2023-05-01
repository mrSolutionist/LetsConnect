//
//  SocialMediaProfileModel.swift
//  LetsConnect
//
//  Created by HD-045 on 27/04/23.
//

import Foundation


struct SocialMediaProfile: Identifiable {
    let id = UUID()
    let profileImageName: String?
    let socialMediaIcon: String?
    let profileURL: String?
    let platform: SocialMediaPlatform
    
    
    init(platform: SocialMediaPlatform, profileURL: String) {
        self.platform = platform
        self.profileImageName = nil // set profileImageName to the raw value of platform
        self.socialMediaIcon = platform.rawValue // set socialMediaIcon to the raw value of platform
        self.profileURL = profileURL // or provide a default URL if you have one
    }

}

enum SocialMediaPlatform : String{
    
    case Instagram = "instagram"
    case Facebook = "facebook"
    case LinkedIn = "linkedIn"
    case Youtube = "youtube"
    case Whatsapp = "whatsapp"
    case Twitter = "twitter"
    case StackOverFlow = "stack-overflow"
    case Other = "Other"
}
