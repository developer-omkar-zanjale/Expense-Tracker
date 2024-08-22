import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "UserData")
        
        container.loadPersistentStores { (storeDescription, error) in
            print("")
            print(storeDescription.url ?? "")
            print("")
            if let error = error as NSError? {
                fatalError("Container load failed: \(error)")
            }
        }
    }
}
