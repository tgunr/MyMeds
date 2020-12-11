//
//  MyMedsApp.swift
//  MyMeds
//
//  Created by Dave Carlton on 9/23/20.
//

import SwiftUI

@main
struct MyMedsApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var persistentStore = PersistentStore.shared
    @FetchRequest(fetchRequest: Medicine.allMedicinesFetchRequest()) var medications: FetchedResults<Medicine>

    var body: some Scene {
        WindowGroup {
            MedicationList(delegate: RootViewController())
                .environment(\.managedObjectContext, persistentStore.context)
                .environmentObject(UserData())
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
                case .active:
                    print("active")
                case .inactive:
                    print("inactive")
                case .background:
                    print("background")
                    saveContext()
                @unknown default:
                    print("unkown")
            }
        }
    }
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

struct MyMedsApp_Previews: PreviewProvider {
    @FetchRequest(fetchRequest: Medicine.allMedicinesFetchRequest()) var medications: FetchedResults<Medicine>
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
