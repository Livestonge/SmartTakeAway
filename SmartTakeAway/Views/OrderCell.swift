//
//  OrderTableviewCell.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 12/06/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell, FoodCell {
    
    @IBOutlet weak var FoodName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var drink: UILabel!
    @IBOutlet weak var saus: UILabel!

    static var identifier = String(describing: OrderCell.self )
    
    func populateLabelsWith(_ food: Food) {
        FoodName.text = food.name
        let drinks = "\(String(describing: food.drink!))"
        drink.text = drinks
        let sauce_1 = "\(String(describing: food.sauce_1!))"
        let sauce_2 = "\(String(describing: food.sauce_2!))"
        saus.text = sauce_1 + ", " + sauce_2
        price.text = "\(food.priceAmount)€"
        
    }
    
    

}
