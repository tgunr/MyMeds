//
//  AddMedication.swift
//  MyMeds
//
//  Created by Dave Carlton on 12/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

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


struct AddMedication: View {
    @State private var med: Medication = Medication()

    var body: some View {
        List {
//            let image = med.image
//            CircleImage(name: image)
            TextField("Name:", text: $med.name)
        Spacer()
            Button(action: {
                PersistentStore.shared.addMed(newMed: med)
            }) {
                Text("Save")
                }
        }
//        .NavigationBarTitle("Add")
        
    }
    
//    private func addItem() -> Medicine {
//        withAnimation {
//            let med = Medicine(context: managedObjectContext)
//            med.name = "Medication"
//            med.start = Date()
//            med.category = "pain"
//            med.dosage = 1
//            med.essential = true
//            med.frequeny = 24
//            med.id = UUID()
//            med.imagename = "pill"
//            med.interval = "daily"
//            med.kind = "pill"
//            med.refilled = Date()
//            med.quantity = 60
//            med.notify = true
//            med.notifylevel = 10
//
//            return med
//        }
//    }
}

struct AddMedication_Previews: PreviewProvider {
    static var previews: some View {
        AddMedication()
    }
}
