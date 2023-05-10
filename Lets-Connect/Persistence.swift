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
        
        do {
            try container.viewContext.save()
            print("New social profile saved to Core Data.")
        } catch let error {
            print("Error saving social profile to Core Data: \(error.localizedDescription)")
        }
    }
    
    func updateSocialProfile(profile: SocialMediaProfile ){

        let request = NSFetchRequest<SocialProfiles>(entityName: "SocialProfiles")

   
        request.predicate = NSPredicate(format: "id == %@", profile.id as CVarArg)

        do {
            let results = try container.viewContext.fetch(request)
            if let updatedProfile = results.first {
                // Update the person's age
                updatedProfile.platform = profile.platform.rawValue
                updatedProfile.profileURL = profile.profileURL
                updatedProfile.profileImageName = profile.profileImageName
                updatedProfile.socialMediaIcon = profile.socialMediaIcon
                
                // Save the changes to the context
                try container.viewContext.save()
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

    
    

}
