//
//  Medicine+CoreDataProperties.swift
//  MyMeds
//
//  Created by Dave Carlton on 9/22/20.
//  Copyright © 2020 Apple. All rights reserved.
//
//

import Foundation
import CoreData


extension Medicine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicine> {
        return NSFetchRequest<Medicine>(entityName: "Medicine")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var category: String?
    @NSManaged public var kind: String?
    @NSManaged public var essentail: Bool
    @NSManaged public var imagename: String?
    @NSManaged public var dosage: Int16
    @NSManaged public var frequeny: Int16
    @NSManaged public var interval: String?
    @NSManaged public var refilled: Date?
    @NSManaged public var quantity: Int16
    @NSManaged public var notify: Bool
    @NSManaged public var notifylevel: Int16

}

extension Medicine : Identifiable {

}
