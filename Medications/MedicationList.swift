/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view showing a list of medications.
 */

import SwiftUI
import CoreData

struct MedicationListToolbar: View {
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

struct SecondView: View {
    var body: some View {
        Text("Hello, Second View!")
            .font(.largeTitle)
            .fontWeight(.medium)
            .foregroundColor(Color.blue)
    }
}

struct MedicationList: View {
    @EnvironmentObject private var userData: UserData
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var medications: FetchedResults<Medicine>
    
    @State private var addMode = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Text("Count: \(medications.count)")
                    Toggle(isOn: $userData.showEssentialOnly) {
                        Text("Show Essential Only")
                    }
                    ForEach(medications) { medication in
                        if !self.userData.showEssentialOnly || medication.essential {
                            NavigationLink(
                                destination: MedicationDetail(medication: medication)
                                    .environmentObject(self.userData)
                            ) {
                                MedicationRow(medication: medication)
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                Spacer()
            }
            .navigationTitle("Medications ")
            .navigationBarTitle("Medications" ,displayMode: .automatic)
            .toolbar {
                ToolbarItem( placement: .navigationBarLeading ) {
                    EditButton() }
                ToolbarItem( placement: .navigationBarLeading, content: {
                    Button(action: {
                        deleteAll(medications)
                    }, label: {
                        Text("Delete")
                    })
                })
                ToolbarItem( placement: .automatic )
                {
                    NavigationLink(
                        destination: MedicationDetail(medication: addItem())
                    ){
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    func deleteAll(_ medications: FetchedResults<Medicine>) {
        let context = self.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DataModel")
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        //        if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil)
        for result in medications {
            context.delete(result)
        }
    }

    private func addItem() -> Medicine {
        withAnimation {
            let med = Medicine(context: viewContext)
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
                try viewContext.save()
                return med
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                medications[$0]
            }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


// invisible link inside NavigationView for add mode
struct MedicationsList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MedicationList()
                .preferredColorScheme(.dark)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .environmentObject(UserData())
        }
    }
}
