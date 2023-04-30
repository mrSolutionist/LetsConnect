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
    let platform: String?
    
}
