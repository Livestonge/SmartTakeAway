//
//  OrderTableviewCell.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 12/06/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

// Custom uitableViewCell for configuring the details for an order.
class OrderCell: UITableViewCell {
    @IBOutlet var FoodName: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var drink: UILabel!
    @IBOutlet var saus: UILabel!

    //    Identifier used by a tableview to dequeue a order cell.
    static var identifier = String(describing: OrderCell.self)

    //    Configuring the cell with a order item.
    func populateLabelsWith(_ food: OrderedFood) {
        FoodName.text = food.name
        let drinks = "\(String(describing: food.drink))"
        drink.text = drinks
        saus.text = food.sauces
        price.text = "\(food.price)€"
    }
}
