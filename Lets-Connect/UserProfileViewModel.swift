//
//  UserProfileViewModel.swift
//  LetsConnect
//
//  Created by HD-045 on 28/04/23.
//

import Foundation
import SwiftUI
import PhotosUI
import CoreTransferable
class UserProfileViewModel:ObservableObject{
    let db: DataModel = .shared
    @Published private(set) var imageState: ImageState = .empty
    
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    
    @Published var pickedImageItem: PhotosPickerItem? = nil {
        didSet {
            if let pickedImageItem {
                let progress = loadTransferable(from: pickedImageItem)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }

    @Published var userImageData: Data? {
        didSet{
            let uiImage = UIImage(data: userImageData!)
            
            self.imageState = .success(Image(uiImage: uiImage!))
        }
      
    }
    
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
    
    func updateUserProfile(userId: String, imageData: Data){
        db.updateUserEntity(userId: userId, imageData: imageData)
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.pickedImageItem else {
                    print("Failed to get the selected item.")
                    return
                }
                print(result)
                switch result {
                case .success(let data?):
                    self.userImageData = data
                    // Handle the case where profileImage is not nil
                case .success(nil):
                    print("Profile image is nil")
                    // Handle the case where profileImage is nil
                case .failure(let error):
                    print(error)
                    // Handle the failure case
                }
            }
        }
    }
    
    

}
