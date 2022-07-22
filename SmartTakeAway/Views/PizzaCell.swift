//
//  PizzaCell.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 01/04/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

class PizzaCell: UITableViewCell, FoodCell{
    

    @IBOutlet weak var pizzaView: UIImageView!
    @IBOutlet weak var pizzaName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var Ingredients: UILabel!
   
    @IBOutlet weak var large: UILabel!
    @IBOutlet weak var grande: UILabel!
    @IBOutlet weak var medium: UILabel!
    
    static var identifier = String(describing: PizzaCell.self)
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        
        if selected{
            let tempView = UIImageView(frame: pizzaView.frame)
            tempView.image = pizzaView.image
            superview!.addSubview(tempView)
                  
            tempView.center.x = center.x - 50
            tempView.center.y = center.y
        
          
        
            UIView.animate(withDuration: 0.5,
                         animations: {
                            tempView.center.x = self.center.x + 150
                            tempView.center.y = self.center.y + 500
                          tempView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                            },
                            completion: { _ in
                               tempView.removeFromSuperview()

                            })
        }
    }
    
    func populateLabelsWith(_ food: Food){
        
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
