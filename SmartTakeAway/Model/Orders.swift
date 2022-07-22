//
//  Orders.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 14/06/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import Foundation

class Orders{
    
    static let shared = Orders()
    var ordersList = [Food]()
    var restaurantName: String?
    var restaurantAdress: String?
    
    private init(){}
}
