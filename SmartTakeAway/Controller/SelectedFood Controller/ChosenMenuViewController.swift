//
//  ChosenMenuViewController.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 07/04/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

class ChosenMenuViewController: UIViewController {

   
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var drinkPicker: UIPickerView!
    @IBOutlet weak var sausPicker: UIPickerView!
    @IBOutlet weak var drinkView: UIImageView!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var orderBtOutlet: UIButton!
    
    @IBOutlet weak var sausView_1: UIImageView!
    @IBOutlet weak var sausLabel_1: UILabel!
    @IBOutlet weak var sausView_2: UIImageView!
    @IBOutlet weak var sausLabel_2: UILabel!
    var pickedAtLeastOneSaus = false
  
    var drinkList: [String] = []
    var sausList: [String] = []
    var foodAccessoryProvider: FoodAccessoryProvider?
    var didCompleteSelectionWith: ((Food) -> Void)?
    
   
    var chosenMenu: Food?{
        didSet{
            self.dishName?.text = chosenMenu?.name ?? ""
            self.ingredients?.text = chosenMenu?.description ?? ""
            self.price?.text = "\(chosenMenu?.priceAmount ??  0)€"
        }
    }
    // MARK: IBActions
  
    @IBAction func selectSaus(_ sender: UIControl){
        sausPicker.isHidden = false
        UIView.animate(withDuration: 0.3){ [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    @IBAction func selectDrink(_ sender: UIControl) {
           drinkPicker.isHidden = false
            UIView.animate(withDuration: 0.3){ [weak self] in
                self?.view.layoutIfNeeded()
            }
  }
    
    @IBAction func makeOrder(_ sender: Any) {
           
       guard var chosenMenu = chosenMenu else {return}
       chosenMenu = pickDrinkAndSauce(chosenMenu)
       self.didCompleteSelectionWith?(chosenMenu)
      }
    
    private func pickDrinkAndSauce(_ chosenMenu: Food) -> Food{
       var menu = chosenMenu
       menu.drink = menu.drink ?? self.drinkLabel.text!
       menu.sauce_1 = menu.sauce_1 ?? self.sausLabel_1.text!
       menu.sauce_2 = menu.sauce_2 ?? self.sausLabel_2.text!
       return menu
    }
    
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drinkPicker.dataSource = self
        drinkPicker.delegate = self
        drinkPicker.backgroundColor = .orange

        sausPicker.dataSource = self
        sausPicker.delegate = self
        sausPicker.backgroundColor = .orange
        
        orderBtOutlet.layer.cornerRadius = 30
        orderBtOutlet.isEnabled = false
        foodAccessoryProvider = FoodAccessoryProviding()
        foodAccessoryProvider?.delegate = self
        foodAccessoryProvider?.getFoodAccessories()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let chosenFood = chosenMenu else {return}
        self.dishName?.text = chosenFood.name
        self.ingredients?.text = chosenFood.description
        self.price?.text = "\(chosenFood.priceAmount)€"
    }
    
    // MARK:- Animation
    
    func configureDrinkViews(_ selectedDrink: String){
        
        animateTransitionWith(customView: drinkPicker){ [weak self]_ in
            
            self?.drinkView.isHidden = false
            self?.drinkLabel.text = selectedDrink.capitalized
            self?.chosenMenu!.drink = self?.drinkLabel.text!
            self?.drinkPicker.alpha = 1.0
            self?.view.layoutIfNeeded()
        }
    }
    
   func configureSausViews(_ selectedSaus: String){
        
        if !pickedAtLeastOneSaus{
            pickedAtLeastOneSaus = !pickedAtLeastOneSaus
            
            animateTransitionWith(customView: sausPicker){ [weak self]_ in
                self?.sausView_1.isHidden = false
                self?.sausLabel_1.text = selectedSaus.capitalized
                self?.chosenMenu?.sauce_1 = self?.sausLabel_1.text!
                self?.orderBtOutlet.isEnabled = true
                self?.sausPicker.alpha = 1.0
                self?.view.layoutIfNeeded()
            }
            
        } else {
            pickedAtLeastOneSaus = !pickedAtLeastOneSaus
            
            animateTransitionWith(customView: sausPicker){ [weak self]_ in
                self?.sausView_2.isHidden = false
                self?.sausLabel_2.text = selectedSaus.capitalized
                self?.chosenMenu?.sauce_2 = self?.sausLabel_2.text!
                self?.sausPicker.alpha = 1.0
                self?.view.layoutIfNeeded()
            }

        }
    }
}
