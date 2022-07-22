//
//  SelectControl.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 18/04/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class SelectControl: UIControl{
    
    @IBOutlet weak var labelText: UILabel!
    override  func awakeFromNib() {
           super.awakeFromNib()
           addView()
       }
       
       override func prepareForInterfaceBuilder() {
           super.prepareForInterfaceBuilder()
           addView()
       }
       
       override func layoutSubviews() {
           super.layoutSubviews()
           layer.cornerRadius = 30
       }
       
       private func addView(){
           
           let view = Bundle(for: SelectButton.self).loadNibNamed("\(SelectButton.self)", owner: self, options: nil)![0] as! SelectButton
          
           self.addSubview(view)
           
           view.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
               view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
               view.widthAnchor.constraint(equalTo: self.widthAnchor),
               view.heightAnchor.constraint(equalTo: self.heightAnchor)
           ])
       }
}

class SelectButton: UIButton{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 30
    }
}

class SelectDrink: SelectControl{
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        labelText.text = "Select a drink"
    }
}

class SelectSaus: SelectControl{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        labelText.text = "Select a saus"
    }
    
}


