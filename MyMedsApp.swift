//
//  MyMedsApp.swift
//  MyMeds
//
//  Created by Dave Carlton on 9/23/20.
//

import SwiftUI
import CoreData

@main
struct MyMedsApp: App {
    @Environment(\.scenePhase) private var scenePhase
    private var persistentStore = PersistentStore.shared

    var body: some Scene {
        let testItems = TestItems(context: persistentStore.mco)
        testItems.reset()
        try! testItems.context.save()
//        let f = testItems.getFirst()
        return WindowGroup {
            MedicationsList()
                .environment(\.managedObjectContext, persistentStore.mco)
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
                    persistentStore.save()
                @unknown default:
                    print("unkown")
            }
        }
    }
}

struct MyMedsApp_Previews: PreviewProvider {
//    @FetchRequest(fetchRequest: Medicine.allMedicinesFetchRequest()) var medications: FetchedResults<Medicine>
    
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
