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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if selected{
            let tempView = UIImageView(frame: dishView.frame)
            tempView.image = dishView.image
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
        
        dishName.text = food.name
        dishDescription.text = food.description
        let image = food.image!
        dishView.image = UIImage(named: image)
        priceLabel.text = "\(food.priceAmount)€"
    }
}
