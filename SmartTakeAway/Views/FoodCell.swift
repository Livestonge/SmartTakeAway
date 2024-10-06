//
//  FoodCell.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 29/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

// Protocol for creating an common interface to different custom uitableviewCell
protocol FoodCell: UITableViewCell {
    static var identifier: String { get }
    func populateLabelsWith(_ food: Food)
}

// Custom uitableViewCell for configuring the details for a sandwich.
class SandwichCell: UITableViewCell, FoodCell {
    @IBOutlet var dishView: UIImageView!
    @IBOutlet var dishName: UILabel!
    @IBOutlet var dishDescription: UILabel!
    @IBOutlet var priceLabel: UILabel!

    //    Identifier used by a tableview to dequeue a sandwich cell.
    static var identifier = String(describing: SandwichCell.self)

    // Configuring the cell with a food item.
    func populateLabelsWith(_ food: Food) {
        dishName.text = food.name
        dishDescription.text = food.description
        let image = food.image!
        dishView.image = UIImage(named: image)
        priceLabel.text = "\(food.priceAmount)€"
    }
}
