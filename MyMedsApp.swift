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
    @StateObject private var persistentStore = PersistentStore.shared
//    @FetchRequest(fetchRequest: Medicine.allMedicinesFetchRequest()) var medications: FetchedResults<Medicine>

    var body: some Scene {
        WindowGroup {
            MedicationsList()
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
