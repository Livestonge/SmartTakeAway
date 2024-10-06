//
//  RestaurantView.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 16/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import Foundation
import MapKit

// Creating a subclass for a restaurant illustration in the map.
class RestaurantView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // Text for representing a restaurant in the map
            glyphText = "🌯"
            markerTintColor = UIColor.yellow
        }
    }
}
