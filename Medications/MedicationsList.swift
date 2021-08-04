//
//  MedicationsList.swift
//  MyMeds
//
//  Created by Dave Carlton on 12/13/20.
//  Copyright © 2020 Apple. All rights reserved.
//
//  Abstract:
//  A view showing a list of medications in the database

import SwiftUI
import CoreData

struct MedicationsListToolbar: View {
    var medications: FetchedResults<Medicine>
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        NavigationView {
            HStack(alignment: .top, spacing: 10) {
                EditButton()
                Button(action: {
                    medications.forEach(viewContext.delete)
                }, label: {
                    Text("Delete All")
                })
                Text("                                         ")
            }
        }
    }
}

struct MedicationsList: View {
    @EnvironmentObject private var userData: UserData
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(fetchRequest: Medicine.allMedicinesFetchRequest()) var medications: FetchedResults<Medicine>
    
    @State var addMode = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Text("Count: \(medications.count)")
                    Toggle(isOn: $userData.showEssentialOnly) {
                        Text("Show Essential Only")
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
                // Adding this item causes 2 instances to be created on Mac! Why?
                //                ToolbarItem( placement: .navigationBarLeading, content: {
                //                    Button(action: {
                //                        deleteAll(medications)
                //                    }, label: {
                //                        Text("Delete")
                //                    })
                //                })
                ToolbarItem( placement: .automatic )
                {
                    NavigationLink(
                        destination: AddMedication(isPresented: $addMode)
                    ){
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    func deleteAll(_ medications: FetchedResults<Medicine>) {
        let context = self.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DataModel")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        //        if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil)
        for result in medications {
            context.delete(result)
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

struct MedicationsList_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistentStore.shared.mco
        let testItems = TestItems(context: context)
        testItems.reset()
//        try! testItems.context.save()
        
        return MedicationsList()
            .preferredColorScheme(.dark)
            .environment(\.managedObjectContext, testItems.context)
            .environmentObject(UserData())
    }
}

