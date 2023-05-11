//
//  UserProfileViewModel.swift
//  LetsConnect
//
//  Created by HD-045 on 28/04/23.
//

import Foundation


class UserProfileViewModel:ObservableObject{
    let db: DataModel = .shared
    
    @Published var receivedProfile: String =  String() {
        didSet {
            DispatchQueue.main.async {
                // Call your view update method here
                self.profileReceivedStatus()
                
            }
           
        }
       
    }
    @Published var profileSelectedForUpdate: SocialProfiles?
    @Published var activeProfileIndex: Int = 0 {
          didSet {
              updateSelectedProfile()
          }
      }
      
    var selectedProfile: SocialProfiles?
      
      init() {
          updateSelectedProfile()
          fetchSocialProfiles()
      }
      
      private func updateSelectedProfile() {
          guard !dbDataSocialProfiles.isEmpty, dbDataSocialProfiles.indices.contains(activeProfileIndex) else {
              selectedProfile = nil
              return
          }
          selectedProfile = dbDataSocialProfiles[activeProfileIndex]
      }
    
    @Published var addProfile: Bool = false
    @Published var receivedStatus: Bool = false
    @Published var dbDataSocialProfiles: [SocialProfiles] = []
    
   
    func addSocialProfile(platform: SocialMediaPlatform, url: String) {
        let newProfile = SocialMediaProfile(platform: platform, profileURL: url)

        db.addSocialProfileToCoreData(profile: newProfile)
        fetchSocialProfiles()
    }
    
    func updateSocialProfile(platform: SocialMediaPlatform, url: String, oldProfile: SocialProfiles) {
        let updatedProfile = SocialMediaProfile(platform: platform, profileURL: url)
        db.updateSocialProfile(newProfile: updatedProfile, oldProfile: oldProfile)
        profileSelectedForUpdate = nil
    }
    
    func deleteSocialProfile(for profile: SocialProfiles) {
        db.deleteSocialProfile(profile: profile)
        fetchSocialProfiles()
        
    }
    
    private func profileReceivedStatus() {
        receivedStatus.toggle()
    }
    
    func fetchSocialProfiles(){
        dbDataSocialProfiles = db.fetchSocialProfileData() ?? []
    }
}
