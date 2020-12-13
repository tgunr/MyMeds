//
//  Persistence.swift
//  temp
//
//  Created by Dave Carlton on 9/22/20.
//

import CoreData

class PersistentStore: ObservableObject {
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
        // One line singleton
    static let shared = PersistentStore()
        // Mark the class private so that it is only accessible through the singleton `shared` static property
    private init() {}
    private let persistentStoreName: String = "DataModel"
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistentStoreName)
                // OR - Include the following line for use with CloudKit - NSPersistentCloudKitContainer
        // let container = NSPersistentCloudKitContainer(name: persistentStoreName)
        // Enable history tracking
        // (to facilitate previous NSPersistentCloudKitContainer's to load as NSPersistentContainer's)
        // (not required when only using NSPersistentCloudKitContainer)
        guard let persistentStoreDescriptions = container.persistentStoreDescriptions.first else {
            fatalError("\(#function): Failed to retrieve a persistent store description.")
        }
        persistentStoreDescriptions.setOption(true as NSNumber,
                                              forKey: NSPersistentHistoryTrackingKey)
        persistentStoreDescriptions.setOption(true as NSNumber,
                                              forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                fatalError("Unresolved error \(error)")
            }
        })
                // Include the following line for use with CloudKit - NSPersistentCloudKitContainer
//        container.viewContext.automaticallyMergesChangesFromParent = true
                // Include the following line for use with CloudKit and to set your merge policy, for example...
//                container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()

    // MARK: - Core Data Saving and "other future" support (such as undo)
    func save() {
        let context = persistentContainer.viewContext
//        if !context.commitEditing() {
//            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
//        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                print("error: \(nserror)")
                //                NSApplication.shared.presentError(nserror)
            }
        }
    }
}

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for x in 0..<10 {
            let med = Medicine(context: viewContext)
            med.name = "Medication \(x)"
            med.start = Date()
            med.category = "pain"
            med.dosage = 1
            med.essential = true
            med.frequeny = 24
            med.id = UUID()
            med.imagename = "pill"
            med.interval = "daily"
            med.refilled = Date()
            med.quantity = 60
            med.notify = true
            med.notifylevel = 10
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    static var preview1: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let med = Medicine(context: viewContext)
        med.name = "Medication 1"
        med.start = Date()
        med.category = "pain"
        med.dosage = 1
        med.essential = true
        med.frequeny = 24
        med.id = UUID()
        med.imagename = "pill"
        med.interval = "daily"
        med.refilled = Date()
        med.quantity = 60
        med.notify = true
        med.notifylevel = 10
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "DataModel")
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
    }
}
