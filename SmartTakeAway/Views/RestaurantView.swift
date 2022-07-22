//
//  RestaurantView.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 16/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import Foundation
import MapKit


class RestaurantView: MKMarkerAnnotationView{
    
    override var annotation: MKAnnotation?{
        
        willSet{
            glyphText = "🌯"
            markerTintColor = UIColor.yellow
        }
    }
}
