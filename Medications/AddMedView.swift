//
//  AddMedView.swift
//  MyMeds
//
//  Created by Dave Carlton on 12/4/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI
import CoreData

extension PersistentStore {
        
    func addMed() {
        persistentContainer.performBackgroundTask { context in
            let med = Medicine(context: context)
            med.name = "Medication"
            med.start = Date()
            med.category = "pain"
            med.dosage = 1
            med.essential = true
            med.frequeny = 24
            med.id = UUID()
            med.imagename = "pill"
            med.interval = "daily"
            med.kind = "pill"
            med.refilled = Date()
            med.quantity = 60
            med.notify = true
            med.notifylevel = 10
            
            do {
                try context.save()
            } catch {
                print("Something went wrong: \(error)")
                context.rollback()
            }
        }
    }
}

struct AddMedView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @State var isPresented: Bool
    
    let storageProvider: PersistentStore
    
    var body: some View {
        NavigationView {
            Form {
                // A form that's used to configure a task
            }
            .navigationTitle("Add")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }, trailing: Button("Save") {
                // This is the part I want you to focus on
                storageProvider.addMed()
                isPresented = false
            })
        }
    }
    
    //    var body: some View {
    //        let med = addItem()
    //        MedicationDetail(medication: med)
    //    }
    
    private func addItem() -> Medicine {
        withAnimation {
            let med = Medicine(context: managedObjectContext)
            med.name = "Medication"
            med.start = Date()
            med.category = "pain"
            med.dosage = 1
            med.essential = true
            med.frequeny = 24
            med.id = UUID()
            med.imagename = "pill"
            med.interval = "daily"
            med.kind = "pill"
            med.refilled = Date()
            med.quantity = 60
            med.notify = true
            med.notifylevel = 10
            
            return med
        }
    }
}

struct AddMedView_Previews: PreviewProvider {
    @State var present = true
    static var previews: some View {
        AddMedView(isPresented: true, storageProvider: PersistentStore.shared)
    }
}
