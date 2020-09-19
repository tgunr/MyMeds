/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The model for an individual medication.
*/

import SwiftUI
import CoreLocation

struct Medication: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    fileprivate var imageName: String
    fileprivate var coordinates: Coordinates
    var state: String
    var city: String
    var park: String
    var category: Category
    var isFavorite: Bool
    var dosage: Int
    var interval: String
    var refilled: Date
    var quantity: Int
    var notify: Bool
    var notifyLevel: Int

    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }

    enum Category: String, CaseIterable, Codable, Hashable {
        case featured = "Featured"
        case lakes = "Lakes"
        case rivers = "Rivers"
        case mountains = "Mountains"
    }
    
    enum Interval: String, CaseIterable, Codable, Hashable {
        case hourly
        case hours
        case daily
        case days
    }
}

extension Medication {
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}
