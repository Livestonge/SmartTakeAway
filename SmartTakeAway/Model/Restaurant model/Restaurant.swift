//
//  Restaurants.swift
//  Fadira
//
//  Created by awaleh moussa hassan on 10/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit

// Object used represent a restaurant
class Restaurant: NSObject, Decodable {
    static var reUseIdentifier = "cellAdresse"

    let name: String
    var adresse: String
    // Proprieties used to save the coordinates of a restaurant.
    var longitude: Double?
    var latitude: Double?

    init(name: String, adresse: String) {
        self.name = name
        self.adresse = adresse
    }
}

extension Restaurant: MKAnnotation {
    // Required implementation of MKAnnotation.
    var coordinate: CLLocationCoordinate2D {
        guard let latitude = latitude, let longitude = longitude else { fatalError("Coordinate not found") }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    // Title to display in the map.
    var title: String? {
        return name
    }
}
