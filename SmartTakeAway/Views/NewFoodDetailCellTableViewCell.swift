//
//  NewFoodDetailCellTableViewCell.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 06/08/2022.
//

import UIKit

class NewFoodDetailCellTableViewCell: UITableViewCell {
    @IBOutlet var foodTitle: UILabel!
    @IBOutlet var foodDetailDescription: UILabel!
    @IBOutlet var foodPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
