//
//  OrderTableviewCell.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 12/06/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var FoodName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var drink: UILabel!
    @IBOutlet weak var saus: UILabel!

    static var identifier = String(describing: OrderCell.self )
    
    func populateLabelsWith(_ food: OrderedFood) {
        FoodName.text = food.name
        let drinks = "\(String(describing: food.drink))"
        drink.text = drinks
        saus.text = food.sauces
        price.text = "\(food.price)€"
        
    }
    
    

}
