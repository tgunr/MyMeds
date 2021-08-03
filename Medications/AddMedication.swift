//
//  AddMedication.swift
//  MyMeds
//
//  Created by Dave Carlton on 12/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

extension PersistentStore {
    
    func newMed() -> Medicine {
        let med = Medicine(context: persistentContainer.viewContext)
        med.name = "Medication"
        med.start = Date()
        med.category = "pain"
        med.dosage = 1
        med.essential = true
        med.frequency = 24
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
    
    // Create a new Medicine record in database from the values in a Medication instance
    func copyMed(newMed: Medication, med: Medicine) {
        med.name = newMed.name
        med.start = newMed.refilled
        //        med.category = newMed.category
        //        med.dosage = newMed.dosage
        med.essential = newMed.essential
        //        med.frequeny = newMed.frequency
        med.id = UUID()
        med.imagename = "pill"
        //        med.interval = newMed.interval
        med.kind = newMed.kind
        //        med.refilled = newMed.refilled
        //        med.quantity = newMed.quantity
        med.notify = newMed.notify
        //        med.notifylevel = newMed.notifyLevel
    }
    
    func addMed(_ instanceOf: Medication) {
        persistentContainer.performBackgroundTask { context in
            let med = Medicine(context: self.persistentContainer.viewContext)
            self.copyMed(newMed: instanceOf, med: med)
            do {
                try context.save()
            } catch {
                print("Something went wrong: \(error)")
                context.rollback()
            }
        }
    }
}

struct AddTopView: View {
    
    @State private var medName = "MedName"
    var body: some View {
        CircleImage(name: "percocet.jpg")
            .padding(.top)
        HStack() {
            TextField("Name:", text: $medName)
            Spacer()
        }
    }
}

// Create a Medication instance and use the view to fill in the values
// When save button is selected, send the Medication to the PersistentStore

struct AddMedication: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var medInstance: Medication = Medication()
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    //            let image = med.image
                    //            CircleImage(name: image)
                    TextField("Name:", text: $medInstance.name)
                    Spacer()
                }
            }
            .navigationTitle("New Medication")
            .navigationBarItems(leading: Button("Cancel") {
                self.isPresented = false
//                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                PersistentStore.shared.addMed(medInstance)
                self.isPresented = false
//                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

//struct AddMedication_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMedication()
//    }
//}
