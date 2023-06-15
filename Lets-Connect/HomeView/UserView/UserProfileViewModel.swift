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
            UserDefaults.standard.setValue(activeProfileIndex, forKey: "DefaultProfile")
            
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
       
        fetchSocialProfiles()
        loadUserDetails()
        activeProfileIndex =  UserDefaults.standard.integer(forKey: "DefaultProfile")
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
        
            db.updateUserEntity(firstName: firstName, lastName: lastName, phNumber: phoneNumber, imageData: userImageData, email: email)
       
        loadUserDetails()
    }

    
    func deleteUserFromApp(completion: @escaping (Bool) -> Void) {
        if let userId = UserDefaults.standard.string(forKey: "currentUser") {
            if db.deleteUserEntityFromCoreData(userId: userId) {
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                UserDefaults.standard.removeObject(forKey: "currentUser")
                completion(true) // Notify the completion handler that the user deletion was successful
            } else {
                completion(false) // Notify the completion handler that the user deletion failed
            }
        } else {
            completion(false) // Notify the completion handler that the user is not logged in
        }
    }

    func loadUserDetails(){
        let user = db.fetchUserFromCoreData()
        userImageData = user?.imageData
        firstName = user?.firstName ?? "firstName"
        lastName = user?.lastName  ?? "lastName"
        phoneNumber = user?.phoneNumber  ?? "phoneNumber"
        email = user?.email ?? "email"
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
    
    func reset() {
        // Image loading state
        imageState = .empty
 
        // Picked image item
       pickedImageItem = nil
        
        // User image data
        userImageData = nil

        // Selected profile for update
        profileSelectedForUpdate = nil
        
        // Active profile index
       activeProfileIndex = 0
        
        // Selected profile
        selectedProfile = nil
        
        // Add profile flag
       addProfile = false
        
        // Profile received status flag
       receivedStatus = false
        
        // Data for social profiles
        dbDataSocialProfiles = []
        firstName = String()
     lastName = String()
       email = String()
       phoneNumber = String()
       }

     func dismissKeyboard() {
             UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
         }

}
