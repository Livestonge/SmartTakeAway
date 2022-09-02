//
//  Orders.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 14/06/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import Foundation
// A user can make select many food within an order
struct Order {
    var foodsList = [OrderedFood]()
    // The details of the restaurant.
    var restaurantName: String?
    var restaurantAdress: String?
}
