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

class UserProfileViewModel: ObservableObject {
    let db: DataModel = .shared
    
    // Image loading state
    @Published private(set) var imageState: ImageState = .empty
    @Published var firstName: String = String()
    @Published var lastName: String = String()
    @Published var email: String = String()
    @Published var phoneNumber: String = String()
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    // Picked image item
    @Published var pickedImageItem: PhotosPickerItem? = nil {
        didSet {
            if let pickedImageItem = pickedImageItem {
                loadTransferable(from: pickedImageItem)
            }
        }
    }
    
    // User image data
    @Published var userImageData: Data?
    
    // Profile update status
    @Published var receivedProfile: String = String() {
        didSet {
            DispatchQueue.main.async {
                self.profileReceivedStatus()
            }
        }
    }
    
    // Selected profile for update
    @Published var profileSelectedForUpdate: SocialProfiles?
    
    // Active profile index
    @Published var activeProfileIndex: Int = 0 {
        didSet {
            updateSelectedProfile()
        }
    }
    
    // Selected profile
    var selectedProfile: SocialProfiles?
    
    // Add profile flag
    @Published var addProfile: Bool = false
    
    // Profile received status flag
    @Published var receivedStatus: Bool = false
    
    // Data for social profiles
    @Published var dbDataSocialProfiles: [SocialProfiles] = []
 
    
    init() {
        
        updateSelectedProfile()
        fetchSocialProfiles()
        loadUserDetails()
    }
    
    // Update the selected profile
    private func updateSelectedProfile() {
        guard !dbDataSocialProfiles.isEmpty, dbDataSocialProfiles.indices.contains(activeProfileIndex) else {
            selectedProfile = nil
            return
        }
        selectedProfile = dbDataSocialProfiles[activeProfileIndex]
    }
    
    // Add a social profile
    func addSocialProfile(platform: SocialMediaPlatform, url: String) {
        let newProfile = SocialMediaProfile(platform: platform, profileURL: url)
        
        db.addSocialProfileToCoreData(profile: newProfile)
        fetchSocialProfiles()
    }
    
    // Update a social profile
    func updateSocialProfile(platform: SocialMediaPlatform, url: String, oldProfile: SocialProfiles) {
        let updatedProfile = SocialMediaProfile(platform: platform, profileURL: url)
        db.updateSocialProfile(newProfile: updatedProfile, oldProfile: oldProfile)
        profileSelectedForUpdate = nil
    }
    
    // Delete a social profile
    func deleteSocialProfile(for profile: SocialProfiles) {
        db.deleteSocialProfile(profile: profile)
        fetchSocialProfiles()
    }
    
    // Toggle received status
    private func profileReceivedStatus() {
        receivedStatus.toggle()
    }
    
    // Fetch social profiles
    func fetchSocialProfiles() {
        dbDataSocialProfiles = db.fetchSocialProfileData() ?? []
    }
    
    // Update user profile image data
    func updateUserProfile() {
        guard let data  = userImageData else {
            return
        }
        
        db.updateUserEntity(firstName: firstName, lastName: lastName, phNumber: phoneNumber, imageData: data, email: email)
        loadUserDetails()
    }
    
    func loadUserDetails(){
        let user = db.fetchUserFromCoreData()
        userImageData = user?.imageData
        firstName = user?.firstName ?? "No Data"
        lastName = user?.lastName  ?? "No Data"
        phoneNumber = user?.phoneNumber  ?? "No Data"
        email = user?.email ?? "No Data"
    }
    
    // Load transferable image data from picked item
    private func loadTransferable(from imageSelection: PhotosPickerItem)  {
        imageSelection.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.pickedImageItem else {
#if DEBUG
                    print("Failed to get the selected item.")
#endif
                   
                    return
                }
#if DEBUG
                print(result)
#endif
                
                switch result {
                case .success(let data?):
                    self.userImageData = data
                    // Handle the case where profileImage is not nil
                case .success(nil):
#if DEBUG
                    print("Profile image is nil")
#endif
                    
                    // Handle the case where profileImage is nil
                case .failure(let error):
#if DEBUG
                    print(error)
#endif
                   
                    // Handle the failure case
                }
            }
        }
    }
    

     func dismissKeyboard() {
             UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
         }

}
