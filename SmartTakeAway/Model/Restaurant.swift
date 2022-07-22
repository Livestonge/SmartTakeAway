//
//  Restaurants.swift
//  Fadira
//
//  Created by awaleh moussa hassan on 10/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit


class Restaurant: NSObject,Decodable{
    
    static var reUseIdentifier = "cellAdresse"
    
    let name: String
    var adresse: String
    var longitude: Double?
    var latitude: Double?
    
    init(name: String, adresse: String){
        
        self.name = name
        self.adresse = adresse
    }

}

extension Restaurant: MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D{
        guard let latitude = latitude, let longitude = longitude else {fatalError("Coordinate not found")}
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String?{
        return name
    }
}
