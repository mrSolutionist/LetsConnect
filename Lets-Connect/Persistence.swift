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
            }
        } catch {
            print("Failed to fetch profile: \(error)")
        }

    }

    func fetchSocialProfileData() -> [SocialProfiles]? {
        let fetchRequest = NSFetchRequest<SocialProfiles>(entityName: "SocialProfiles")
        
        do {
            let data = try container.viewContext.fetch(fetchRequest)
            return data
        } catch {
            print("Could not fetch data: \(error.localizedDescription)")
            return nil
        }
    }


    
    func deleteSocialProfile(profile: SocialProfiles) {
        let context = container.viewContext
        
        context.delete(profile)
    }


    
    func addUserToCoreData(user: AppleUser) {
        
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId == %@", user.userId)
        
        do {
            let existingUsers = try container.viewContext.fetch(fetchRequest)
            
            if let existingUser = existingUsers.first {
                // User with the same userId already exists, handle the case accordingly
                print("User with userId \(user.userId) already exists")
            } else {
                // User does not exist, create a new user
                let newUser = UserEntity(context: container.viewContext)

                newUser.userId = user.userId
                newUser.firstName = user.firstName
                newUser.lastName = user.lastName
                newUser.imageData = nil
             
               
            }
        } catch {
            print("Error fetching user from Core Data: \(error)")
        }
    }
    
    func updateUserEntity(userId: String, imageData: Data){
        
        let request : NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        do {
            let results = try container.viewContext.fetch(request)
            if let updatedUser = results.first {
                updatedUser.imageData = imageData
                
            }
        } catch {
            print("Failed to fetch profile: \(error)")
        }
    }

    func fetchUserFromCoreData(userId: String) -> UserEntity? {
        let request :NSFetchRequest<UserEntity> =  UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        do {
            let result = try container.viewContext.fetch(request)
            return result.first
        }
        catch{
            print("error fetch user")
        }
        return nil
    }
    
 
    
    func saveContext() {
        let context = container.viewContext
        
        do {
            try context.save()
            print("Changes saved to Core Data.")
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
