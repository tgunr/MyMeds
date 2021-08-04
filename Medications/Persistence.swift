//
//  Persistence.swift
//  temp
//
//  Created by Dave Carlton on 9/22/20.
//

import CoreData

extension String: Error {}

protocol TestProtocol {
    var context: NSManagedObjectContext {get}
    var entityName: String {get}
    func addRows() throws
    func getRows() throws -> [Any]?
}

class TestData: TestProtocol {
    var context: NSManagedObjectContext
    var entityName: String = "Medicine"
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func noRowsExist() -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        let count = try! context.count(for: fetchRequest)
        return count == 0
    }
    
    func getRows() throws -> [Any]? {
        try! addRows()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        return try? context.fetch(fetchRequest)
    }
    
    func getRows<T>(count: Int) throws -> [T] {
        let fullList:[T] = try self.getRows() as! [T]
        return Array(fullList.prefix(count))
    }
    
    func addRows() throws {
        throw "Function not overridden"
    }
    
    func reset() {
        let delete = NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: self.entityName))
        let coordinator = context.persistentStoreCoordinator
        try! coordinator?.execute(delete, with: context)
        let _ = try! getRows()
    }
}

class TestItems: TestData {
    override func getRows() throws -> [Any]? {
        return try super.getRows()
    }
    
    func getRows(count: Int) throws -> [Medicine] {
        return try super.getRows(count: count)
    }
    
    func getFirst() -> Medicine {
        do {
            let rows = try getRows(count: 1)
            guard let row = rows.first else { return newMed() }
            return row
        } catch { return newMed() }
    }
    
    func setMed(med: Medicine, index: Int) -> Medicine {
        med.name = "Medication \(index)"
        med.start = Date()
        med.category = "pain"
        med.dosage = 1
        med.essential = true
        med.frequency = 24
        med.id = UUID()
        med.imagename = "pill"
        med.interval = "daily"
        med.refilled = Date()
        med.quantity = 60
        med.notify = true
        med.notifylevel = 10
        
        let date = Dates(context: context)
        date.created = Date()
        date.medicine = med.id
        date.start = Date()
        med.dates = date
        
        let history = History(context: context)
        history.taken = Date()
        history.medicine = med.id
        return med
    }
    
    func newMed() -> Medicine {
        return setMed(med: Medicine(context: context), index: 0)
    }
    
    override func addRows() throws {
        if super.noRowsExist() {
            for i in 1...5 {
                _ = setMed(med: Medicine(context: context), index: i)
            }
            try! context.save()
        }
    }
}

class PersistentStore: ObservableObject {
    static let shared = PersistentStore()
    let modelName = "DataModel"
    
    let persistentClouldContainer: NSPersistentCloudKitContainer = {
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        let container = NSPersistentCloudKitContainer.init(name: "DataModel")
        container.persistentStoreDescriptions = [storeDescription]

        container.loadPersistentStores(completionHandler: { storeDescription, error in
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            guard error == nil else {
                assertionFailure("Persistent store '\(storeDescription)' failed loading: \(String(describing: error))")
                return
            }
        })

        guard let persistentStoreDescriptions = container.persistentStoreDescriptions.first else {
            fatalError("\(#function): Failed to retrieve a persistent store description.")
        }
        return container
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer.init(name: modelName)
        // Enable history tracking
        // (to facilitate previous NSPersistentCloudKitContainer's to load as NSPersistentContainer's)
        // (not required when only using NSPersistentCloudKitContainer)
//        guard let persistentStoreDescriptions = container.persistentStoreDescriptions.first else {
//            fatalError("\(#function): Failed to retrieve a persistent store description.")
//        }
//        persistentStoreDescriptions.setOption(true as NSNumber,
//                                              forKey: NSPersistentHistoryTrackingKey)
//        persistentStoreDescriptions.setOption(true as NSNumber,
//                                              forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    var mco: NSManagedObjectContext {
        persistentClouldContainer.viewContext
    }
    
    func save() {
        guard mco.hasChanges else { return }
        do {
            try mco.save()
        } catch {
            print(error)
        }
    }
}

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    static var ptest: PersistenceController = {
        let c = PersistenceController(inMemory: true)
        let v = c.container.viewContext
        let m = Medicine(context: v)
        m.id = UUID()
        m.name = "Test"
        do {
            try v.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return c
    }()
    
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        for i in 0..<10 {
            let med = Medicine(context: viewContext)
            med.name = "Medication \(i)"
            med.start = Date()
            med.category = "pain"
            med.dosage = 1
            med.essential = true
            med.frequency = 24
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
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return controller
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "DataModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
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
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        })
    }
}

