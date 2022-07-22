/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The model for an individual medication.
*/

import SwiftUI
import CoreData

extension Medicine  {
    static func allMedicinesFetchRequest() -> NSFetchRequest<Medicine> {
        let request: NSFetchRequest<Medicine> = Medicine.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }
}

class Medication: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String = "Name"
//    fileprivate var imageName: String = "pill"
    var imagename: String = "pill"
    var kind: String = ""
    var category: Category?
    var essential: Bool = false
    var dosage: Int = 0
    var frequency: Int = 0
    var interval: Interval?
    var refilled: Date?
    var quantity: Int = 0
    var notify: Bool = false
    var notifyLevel: Int = 0

    enum Category: String, CaseIterable, Codable, Hashable {
        case pain
    }
    
    enum Interval: String, CaseIterable, Codable, Hashable {
        case hourly
        case hours
        case daily
        case days
    }
    
    enum Kind: String, CaseIterable, Codable, Hashable {
        case pill
        case liquid
        case injection
        case topical
    }
    
//    init(meds: [Medication]) {
//        meds.append((self))
//    }
}

extension Medication {
    var image: Image {
        ImageStore.shared.image(name: imagename)
    }
}
