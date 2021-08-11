//
//  DosageDetailView.swift
//  MyMeds
//
//  Created by Dave Carlton on 8/5/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SwiftUI

struct DosageDetailView: View {
    var medication: FetchedResults<Medicine>.Element
    var body: some View {
        let frequency = medication.frequency
        Section(header: Text("Dosage")
                    .font(.subheadline)
        ) {
            HStack(alignment: .top) {
                let dose = medication.dosage
                let dosageString = "\(dose) \(medication.kind ?? "kind")"
                Text(dosageString)
                    .font(.subheadline)
                if frequency == 1 {
                    Text("Every Hour")
                } else {
                    Text("Every \(frequency)")

                }
                Spacer()
            }
            .padding(.top, 2.0)
        }
    }
}


struct DosageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistentStore.shared.mco
        let testItems = TestItems(context: context)
        //        testItems.reset()
        let med = testItems.getFirst()
        med.name = "Med Preview"
        return DosageDetailView(medication: med)
    }
}
