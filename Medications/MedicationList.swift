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
                //                NavigationLink(destination: MedicationDetail(medication: addItem())) {
                //                    Image(systemName: "plus")
                //                        .resizable()
                //                        .padding(6)
                //                        .frame(width: 24, height: 24)
                //                        .background(Color.blue)
                //                        .clipShape(Circle())
                //                        .foregroundColor(.white)
                //                }
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
                //                MedicationListToolbar(medications: medications)
                List {
                    Toggle(isOn: $userData.showEssentailOnly) {
                        Text("Show Essential Only")
                    }
                    ForEach(medications) { medication in
                        if !self.userData.showEssentailOnly || medication.essentail {
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
                        medications.forEach(viewContext.delete)
                    }, label: {
                        Text("Delete")
                    })
                })
                ToolbarItem( placement: .automatic )
                {
                    Button(action: {
                        addItem()
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
        }
    }
    
    private func reportSave()
    {
        NavigationLink(destination: MedicationDetail(medication: addItem())) {
            
        }
        
    }
    
    private func reportCancel()
    {
    }
    
    private func addItem() -> Medicine {
        withAnimation {
            let med = Medicine(context: viewContext)
            med.name = "Medication"
            med.start = Date()
            med.category = "pain"
            med.dosage = 1
            med.essentail = true
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
            offsets.map { medications[$0] }.forEach(viewContext.delete)
            
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
