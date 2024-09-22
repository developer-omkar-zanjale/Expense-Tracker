import SwiftUI
import CoreData

struct CoreDataService {
    
    static let shared = CoreDataService()
    let container: NSPersistentContainer
    let logService = LoggerService()
    let userEntityName = "UserData"

    init() {
        container = NSPersistentContainer(name: "UserData")
        
        container.loadPersistentStores { (storeDescription, error) in
            let logService = LoggerService()
            logService.printLog(storeDescription.url ?? "")
            if let error = error as NSError? {
                logService.printLog("CoreDataService: Container load failed: \(error)")
            }
        }
    }
    
    func saveChanges() -> Bool {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                logService.printLog("CoreDataService: Could not save changes to Core Data: \(error.localizedDescription)")
                return false
            }
        }
        return false
    }
}
// MARK: Users
extension CoreDataService {
    
    func createUser(name: String, email: String, password: String, selectedImage: UIImage) -> Bool {
        logService.printLog("CoreDataService: New User record creating...")
        //Encoding password to save
        guard let encodedPass = SecureService.encode(str: password) else {
            logService.printLog("CoreDataService: Failed to create user: Unable to encode password!")
            return false
        }
        let entity = UserData(context: container.viewContext)
        entity.name = name
        entity.email = email
        entity.password = encodedPass
        entity.profileImage = selectedImage.jpegData(compressionQuality: 0.8)
        return saveChanges()
    }
    
    func readUsers(email: String? = nil, fetchLimit: Int? = nil) -> [UserData] {
        
        var results: [UserData] = []
        let request = NSFetchRequest<UserData>(entityName: userEntityName)
        
        if let email = email {
            request.predicate = NSPredicate(format: "email = %@", email)
        }
        if let fetchLimit = fetchLimit {
            request.fetchLimit = fetchLimit
        }
        
        do {
            results = try container.viewContext.fetch(request)
        } catch {
            logService.printLog("CoreDataService: Could not fetch Users from Core Data.")
        }
        logService.printLog("CoreDataService: Getting Users: \(results.count)")
        return results
    }
    
    func updateOrAddUser(name: String, email: String, password: String, selectedImage: UIImage) -> Bool {
        if let entityAlreadyAdded = readUsers(email: email, fetchLimit: 1).first {
            logService.printLog("CoreDataService: User record found! Updating...")
            //Encoding password to save
            guard let encodedPass = SecureService.encode(str: password) else {
                logService.printLog("CoreDataService: Failed to update user: Unable to encode password!")
                return false
            }
            entityAlreadyAdded.name = name
            entityAlreadyAdded.email = email
            entityAlreadyAdded.password = encodedPass
            entityAlreadyAdded.profileImage = selectedImage.jpegData(compressionQuality: 0.8)
            return saveChanges()
        } else {
            return createUser(name: name, email: email, password: password, selectedImage: selectedImage)
        }
    }
    
    func deleteUser(for email: String) -> Bool {
        if let objToDelete = readUsers(email: email, fetchLimit: 1).first {
            logService.printLog("CoreDataService: Deleting User: \(objToDelete.email ?? "-")")
            container.viewContext.delete(objToDelete)
            return saveChanges()
        }
        return false
    }
}
