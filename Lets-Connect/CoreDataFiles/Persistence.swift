import CoreData



struct DataModel {
    static let shared = DataModel()
    
    
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Lets_Connect")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        
    }
    
    
    
    func addSocialProfileToCoreData(profile: SocialMediaProfile) {
        let newProfile = SocialProfiles(context: container.viewContext)
        newProfile.platform = profile.platform.rawValue
        newProfile.profileURL = profile.profileURL
        newProfile.id = profile.id
        newProfile.profileImageName = profile.profileImageName
        newProfile.socialMediaIcon = profile.socialMediaIcon
        saveContext()
        
    }
    
    func updateSocialProfile(newProfile: SocialMediaProfile , oldProfile: SocialProfiles){
        
        let request = NSFetchRequest<SocialProfiles>(entityName: "SocialProfiles")
        
        
        request.predicate = NSPredicate(format: "id == %@", oldProfile.id!.uuidString )
        
        
        do {
            let results = try container.viewContext.fetch(request)
            if let updatedProfile = results.first {
                updatedProfile.id = newProfile.id
                updatedProfile.platform = newProfile.platform.rawValue
                updatedProfile.profileURL = newProfile.profileURL
                updatedProfile.profileImageName = newProfile.profileImageName
                updatedProfile.socialMediaIcon = newProfile.socialMediaIcon
                
                saveContext()
            }
        } catch {
#if DEBUG
            
#endif
            print("Failed to fetch profile: \(error)")
        }
        
    }
    
    func fetchSocialProfileData() -> [SocialProfiles]? {
        let fetchRequest = NSFetchRequest<SocialProfiles>(entityName: "SocialProfiles")
        
        do {
            let data = try container.viewContext.fetch(fetchRequest)
            return data
        } catch {
#if DEBUG
            print("Could not fetch data: \(error.localizedDescription)")
#endif
            
            return nil
        }
    }
    
    
    
    func deleteSocialProfile(profile: SocialProfiles) {
        let context = container.viewContext
        
        context.delete(profile)
        saveContext()
    }
    
    func deleteUserEntityFromCoreData(userId: String) -> Bool {
       
        let request : NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId)
        do {
            let user = try container.viewContext.fetch(request)
            
            if let user = user.first{
                container.viewContext.delete(user)
                return true
            }
#if DEBUG
            print("deleted user from core data")
#endif
           
        } catch {
            
#if DEBUG
            print("Failed to fetch profile: \(error)")
#endif
            return false
        }
        return false
    }
    
    func addUserEntityToCoreData(user: AppleUser) {
        
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId == %@", user.userId)
        
        do {
            let existingUsers = try container.viewContext.fetch(fetchRequest)
            
            if let _ = existingUsers.first {
#if DEBUG
                // User with the same userId already exists, handle the case accordingly
                print("User with userId \(user.userId) already exists")
#endif
                
            } else {
                // User does not exist, create a new user
                let newUser = UserEntity(context: container.viewContext)
                
                newUser.userId = user.userId
                newUser.firstName = user.firstName
                newUser.lastName = user.lastName
                newUser.imageData = nil
                saveContext()
                
            }
        } catch {
#if DEBUG
            print("Error fetching user from Core Data: \(error)")
#endif
            
        }
    }
    
    func addTempUserEntityToCoreData(userId: String) {
        
        // User does not exist, create a new user
        let newUser = UserEntity(context: container.viewContext)
        newUser.userId = userId
        saveContext()
        
    }
    
    func updateUserEntity( firstName: String, lastName:String, phNumber:String, imageData: Data?, email: String) {
        guard let userId: String =  UserDefaults.standard.string(forKey: "currentUser") else {
            return
        }
        let request : NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        do {
            let results = try container.viewContext.fetch(request)
            if let updatedUser = results.first {
                updatedUser.imageData = imageData
                updatedUser.firstName = firstName
                updatedUser.lastName = lastName
                updatedUser.phoneNumber = phNumber
                updatedUser.email = email
                saveContext()
            }
        } catch {
#if DEBUG
            print("Failed to fetch profile: \(error)")
#endif
            
        }
    }
    
    func fetchUserFromCoreData() -> UserEntity? {
        guard let userId: String =  UserDefaults.standard.string(forKey: "currentUser") else {
            return nil
        }
        let request :NSFetchRequest<UserEntity> =  UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        do {
            let result = try container.viewContext.fetch(request)
            return result.first
        }
        catch{
#if DEBUG
            print("error fetch user")
#endif
            
        }
        return nil
        
        
    }
    
    
    
    func saveContext() {
        let context = container.viewContext
        
        do {
            try context.save()
#if DEBUG
            print("Changes saved to Core Data.")
#endif
            
        } catch {
#if DEBUG
            print("Error saving context: \(error)")
#endif
            
        }
    }
}
