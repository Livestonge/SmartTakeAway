//
//  UIView.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 02/04/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    func addSubView(view: UIView, constraintTo anchorView: UIView){
        
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: anchorView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: anchorView.centerYAnchor),
            view.widthAnchor.constraint(equalTo: anchorView.widthAnchor),
            view.heightAnchor.constraint(equalTo: anchorView.heightAnchor)
        ])
    }
}

extension ChosenMenuViewController: UIPickerViewDelegate, UIPickerViewDataSource{

// MARK:- UIPickerView

func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1

}

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    if pickerView == self.sausPicker{
             return auxChoixList["Sauce"]!.count
    } else{
             return auxChoixList["Drink"]!.count
    }
}

func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

     if pickerView == self.drinkPicker{
        let drink = auxChoixList["Drink"]!
        return drink[row].capitalized
     }else{
            let drink = auxChoixList["Sauce"]!
            return drink[row].capitalized
    }

}

func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
   
    if pickerView == drinkPicker{
        let drink = auxChoixList["Drink"]!
        let selectedDrink =  drink[row]
        configureDrinkViews(selectedDrink)
    }else if pickerView == sausPicker{
        let saus = auxChoixList["Sauce"]!
        let selectedSaus = saus[row]
        configureSausViews(selectedSaus)
        
    }
}

func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    
    let drinkOrSaus = (pickerView == drinkPicker ? auxChoixList["Drink"]! : auxChoixList["Sauce"]!)
    let text = drinkOrSaus[row]
    let attribute = NSAttributedString(string: text, attributes: [.foregroundColor: UIColor.black])
    return attribute

 }
}
