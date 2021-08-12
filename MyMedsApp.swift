//
//  MyMedsApp.swift
//  MyMeds
//
//  Created by Dave Carlton on 9/23/20.
//

import SwiftUI
import CoreData
import OSLog

var log = Logger()

@main
struct MyMedsApp: App {
    @Environment(\.scenePhase) private var scenePhase
    private var persistentStore = PersistentStore.shared

    var body: some Scene {
        return WindowGroup {
            DashboardView()
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

struct DBResetView: View {
    private var persistentStore = PersistentStore.shared
    var body: some View {
        Button("Reset Database", action: {
            let testItems = TestItems(context: persistentStore.mco)
            testItems.reset()
            try! testItems.context.save()
            log.log("Database Reset")
            //        let f = testItems.getFirst()
        })
        .buttonStyle(BorderedButtonStyle())
    }
}

struct MyMedsApp_Previews: PreviewProvider {
//    @FetchRequest(fetchRequest: Medicine.allMedicinesFetchRequest()) var medications: FetchedResults<Medicine>
    
    static var previews: some View {
        DBResetView()
    }
}
