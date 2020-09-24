//
//  MyMedsApp.swift
//  MyMeds
//
//  Created by Dave Carlton on 9/23/20.
//

import SwiftUI

@main
struct MyMedsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MedicationList()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(UserData())
        }
    }
}

struct MyMedsApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
