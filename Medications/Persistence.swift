//
//  Persistence.swift
//  temp
//
//  Created by Dave Carlton on 9/22/20.
//

import CoreData

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
