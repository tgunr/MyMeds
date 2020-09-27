//
//  ContentView.swift
//
//  Created by Dave Carlton on 9/22/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var items: FetchedResults<Medicine>
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Count: \(items.count)")
                List {
                    ForEach(items) { item in
                        NavigationLink(destination: MedicationDetail(medication: item)) {
                            Text("\(item.name ?? "Name")")
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationBarTitle(Text("Meds"))
            }
        }
        .padding(.bottom)
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
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {        
        ContentView().environment(\.managedObjectContext, PersistenceController.preview1.container.viewContext)
    }
}
