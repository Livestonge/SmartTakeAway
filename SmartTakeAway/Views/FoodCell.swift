//
//  FoodCell.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 29/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

protocol FoodCell: UITableViewCell{
    
    static var identifier: String {get}
    func populateLabelsWith(_ food: Food)
}

class SandwichCell: UITableViewCell, FoodCell{
   
    @IBOutlet weak var dishView: UIImageView!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishDescription: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    static var identifier = String(describing: SandwichCell.self)
    
    func populateLabelsWith(_ food: Food){
        
        dishName.text = food.name
        dishDescription.text = food.description
        let image = food.image!
        dishView.image = UIImage(named: image)
        priceLabel.text = "\(food.priceAmount)€"
    }
}
