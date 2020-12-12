//
//  AddMedView.swift
//  MyMeds
//
//  Created by Dave Carlton on 12/4/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI
import CoreData

struct AddMedView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    var body: some View {
        let med = addItem()
        MedicationDetail(medication: med)
    }
    
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
    static var previews: some View {
        AddMedView()
    }
}
