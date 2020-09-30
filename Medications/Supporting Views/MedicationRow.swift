/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A single row to be displayed in a list of medications.
 */

import SwiftUI
import CoreData

struct MedicationRow: View {
    var medication: FetchedResults<Medicine>.Element
    
    var body: some View {
        HStack(alignment: .center) {
            HStack {
                Text(medication.name ?? "Medication")
                if medication.essentail {
                    Image(systemName: "star.fill")
                        .imageScale(.medium)
                        .foregroundColor(.red)
                } else {
                    Image(systemName: "star")
                }
            }
        }
        
    }
}

struct MedicationRow_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) private var viewContext
    static var previews: some View {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let med = Medicine(context: moc)
        med.name = "Med Preview"
        return  MedicationRow(medication: med)
    }
}

