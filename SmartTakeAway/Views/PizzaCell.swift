//
//  PizzaCell.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 01/04/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

// Custom uitableViewCell for configuring the details for a pizza.
class PizzaCell: UITableViewCell, FoodCell {
    @IBOutlet var pizzaView: UIImageView!
    @IBOutlet var pizzaName: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var Ingredients: UILabel!

    @IBOutlet var large: UILabel!
    @IBOutlet var grande: UILabel!
    @IBOutlet var medium: UILabel!

//    Identifier used by a tableview to dequeue a pizza cell.
    static var identifier = String(describing: PizzaCell.self)

//    Configuring the cell with a food item.
    func populateLabelsWith(_ food: Food) {
        switch food.price {
        case let .pizza(medium: mediumPrice, grande: grandePrice, large: largePrice):
            medium.text = "M:\(mediumPrice)"
            grande.text = "G:\(grandePrice)"
            large.text = "L:\(largePrice)"
        default:
            break
        }

        pizzaName.text = food.name
        Ingredients.text = food.description
        let pizzaImage = food.image!
        pizzaView.image = UIImage(named: pizzaImage)
        price.text = "\(food.priceAmount)€"
    }
}
