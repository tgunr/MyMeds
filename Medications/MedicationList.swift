/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view showing a list of medications.
 */

import SwiftUI
import CoreData

//struct AddMedication: View {
//    @EnvironmentObject private var userData: UserData
//    @State var delegate: NavigationDelegate?
//    //    var medication: Medication
//
//    var body: some View {
//        Button(action: {
//            let newMed = Medication()
//            userData.medications.append(newMed)
//            MedicationDetail(medication: newMed)
//            print("Tapped")
//        }, label: {
//            Text("Add")
//        })
//    }
//}

struct MedicationList: View {
    @EnvironmentObject private var userData: UserData
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var medications: FetchedResults<Medicine>
    
    @State private var addMode = false
    
    var body: some View {
        HStack {
            Text("Count: \(medications.count)")
            Button(action: {
                medications.forEach(viewContext.delete)
            }, label: {
                Text("Delete All")
            })
        }
        NavigationView {
            VStack {
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
                }
                .toolbar(content: {
                    HStack {
                        EditButton()
                        Spacer()
                        Button(action: { addItem() },                                              label: {
                            Image(systemName: "plus")
                                .resizable()
                                .padding(6)
                                .frame(width: 24, height: 24)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        })
                    }
                })
                .navigationBarTitle(Text("Medications"))
            }
        }
    }
        
        private func addItem() {
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
                ContentView()
                    .previewDevice("iPod touch (7th generation)")
                    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                    .environmentObject(UserData())
                ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                    .environmentObject(UserData())
            }
        }
    }
