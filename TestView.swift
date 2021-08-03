//
//  TestView.swift
//  MyMeds
//
//  Created by Dave Carlton on 6/22/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SwiftUI

struct TestView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(fetchRequest: Medicine.allMedicinesFetchRequest()) var medications: FetchedResults<Medicine>
    @State var addMode = false
    var body: some View {
        NavigationView {
            VStack {
                List {
                    VStack {
                        Text("Medications")
                        Text("Count: \(medications.count)")
                    }
                    ForEach(medications) { medication in
                        //                        if !self.userData.showEssentialOnly || medication.essential {
                        NavigationLink(
                            destination: MedicationDetail(medication: medication)
                            //                                    .environmentObject(self.userData)
                        ) {
                            MedicationRow(medication: medication)
                        }
                        //                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationTitle("Medications ")
                .navigationBarTitle("Medications" ,displayMode: .automatic)
                Spacer()
            }
            .toolbar {
                ToolbarItem( placement: .navigationBarLeading ) {
                    EditButton() }
                ToolbarItem( placement: .navigationBarTrailing )
                {
                    NavigationLink(destination: AddMedication(isPresented: $addMode))
                    {
                        Image(systemName: "plus")
                    }
                }

            }
        }
        
    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                medications[$0]
            }.forEach(managedObjectContext.delete)
            
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}

struct TestView_Previews: PreviewProvider {
    @FetchRequest(fetchRequest: Medicine.allMedicinesFetchRequest()) var medications: FetchedResults<Medicine>
    
    static var previews: some View {
        TestView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
