//
//  FoodViewController.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 20/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController {

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var menuStackview: UIStackView!
    
    private var menuTodisplay: [Food] = []
    private var menuProvider: MenuProvider?
    private var sandwichCtrl: SandwichListController?
    
    lazy var pizzaViewController: PizzaViewController = {
        let storyboard = UIStoryboard(name: "Pizza", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "pizzaStoryboard") as! PizzaViewController
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Choose a menu"
      
        for menuView in menuStackview.subviews{
            menuView.tag = menuStackview.subviews.firstIndex(of: menuView)!
            menuView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(handleTaps(sender:)))
            menuView.addGestureRecognizer(tapGesture)
        }
        menuProvider = MenuProviding()
        menuProvider?.delegate = self
        menuProvider?.getMenuFor(.sandwiches)
        sandwichCtrl?.menyList = menuTodisplay
    }
    
   @IBAction func handleTaps(sender: UITapGestureRecognizer){
       
       let menuView = sender.view!
       let index = menuView.tag
       if index == 0{
           pizzaViewController.removeFromParent()
           pizzaViewController.view.removeFromSuperview()
           menuProvider?.getMenuFor(.sandwiches)
           menuTitle.text = "Menu Sandwiches"
       } else if index == 1{
           menuProvider?.getMenuFor(.pizza)
           pizzaViewController.menyList = menuTodisplay
           addChild(pizzaViewController)
           pizzaViewController.didMove(toParent: self)
           pizzaViewController.view.translatesAutoresizingMaskIntoConstraints = false
        // Pushing the pizzaViewController´s view on top of the sandwichController`s view.
           view.addSubView(view: pizzaViewController.view, constraintTo: containerView)
           menuTitle.text = "Menu Pizza"
       } else {
        let alert = UIAlertController(title: "Burger", message: "Burger menu not available😔", preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OK)
        present(alert,animated: true)
       }
          
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "foodSegue" {
             let menuListController = segue.destination as? SandwichListController
             self.sandwichCtrl = menuListController
        }
    }
}


extension FoodViewController: MenuProviderDelegate{
  
  func didReceiveMenu(_ menu: [Food]) {
    self.menuTodisplay = menu
  }
}
