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
