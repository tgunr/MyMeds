//
//  DashboardView.swift
//  MyMeds
//
//  Created by Dave Carlton on 8/11/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SwiftUI
import CoreData

struct DashboardView: View {
    @EnvironmentObject private var userData: UserData
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(fetchRequest: Medicine.allMedicinesFetchRequest()) var medications: FetchedResults<Medicine>

    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                Image(systemName: "checklist")
                Text("Today")
            }
            MedicationsList()
                .tabItem {
                Image(systemName: "pills")
                Text("Medications")
            }
            Text("Hisory")
                .tabItem {
                Image(systemName: "list.bullet.rectangle")
                Text("History")
            }
        }
    }
}



struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistentStore.shared.mco
        let testItems = TestItems(context: context)
        testItems.reset()
        //        try! testItems.context.save()

        return DashboardView()
            .preferredColorScheme(.dark)
            .environment(\.managedObjectContext, testItems.context)
            .environmentObject(UserData())
    }
}

