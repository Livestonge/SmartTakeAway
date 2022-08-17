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
    @IBOutlet weak var menuTypeSegmentCtrl: UISegmentedControl!
  
    private var menuTodisplay: [Food] = []
    private var menuProvider: MenuProvider?
    private var menuTypes: [String] = []
    private var sandwichCtrl: SandwichListController?
    var didCompleteSelection: ((SelectedFood) -> Void)?
  
    lazy var pizzaViewController: PizzaViewController = {
        let storyboard = UIStoryboard(name: "Pizza", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "pizzaStoryboard") as! PizzaViewController
        viewController.didCompleteSelectingWith = didCompleteSelectionWith
      return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Choose a menu"
        menuProvider = MenuProviding()
        menuProvider?.delegate = self
        menuProvider?.getMenuFor(.sandwiches)
        menuProvider?.getMenyTypes()
        sandwichCtrl?.menyList = menuTodisplay
        menuTypeSegmentCtrl.backgroundColor = .white
        menuTypeSegmentCtrl.selectedSegmentTintColor = .orange
        menuTypeSegmentCtrl.removeAllSegments()
        menuTypeSegmentCtrl.addTarget(self,
                                      action: #selector(didSelectSegment),
                                      for: .valueChanged)
      
       for (index, title) in self.menuTypes.enumerated(){
        menuTypeSegmentCtrl.insertSegment(withTitle: title,
                                          at: index,
                                          animated: true)
       }
      menuTypeSegmentCtrl.selectedSegmentIndex = menuTypes.firstIndex(of: "Sandwiches") ?? 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "foodSegue" {
             let menuListController = segue.destination as? SandwichListController
             self.sandwichCtrl = menuListController
            self.sandwichCtrl?.didCompleteSelectingWith = didCompleteSelectionWith
        }
    }
  
  func didCompleteSelectionWith(food: SelectedFood){
    self.didCompleteSelection?(food)
  }
  
//  MARK: Objc
  
  @objc
  func didSelectSegment(){
    let index = self.menuTypeSegmentCtrl.selectedSegmentIndex
    let title = self.menuTypeSegmentCtrl.titleForSegment(at: index)
    if title == "Sandwiches"{
        pizzaViewController.removeFromParent()
        pizzaViewController.view.removeFromSuperview()
        menuProvider?.getMenuFor(.sandwiches)
    } else if title == "Pizza"{
        menuProvider?.getMenuFor(.pizza)
        pizzaViewController.menyList = menuTodisplay
        addChild(pizzaViewController)
        pizzaViewController.didMove(toParent: self)
        pizzaViewController.view.translatesAutoresizingMaskIntoConstraints = false
     // Pushing the pizzaViewController´s view on top of the sandwichController`s view.
        view.addSubView(view: pizzaViewController.view, constraintTo: containerView)
        self.view.bringSubviewToFront(menuTypeSegmentCtrl)
    } else {
     let alert = UIAlertController(title: "Burger", message: "Burger menu not available😔", preferredStyle: .alert)
     let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
     alert.addAction(OK)
     present(alert,animated: true)
    }
    
  }
}


extension FoodViewController: MenuProviderDelegate{
  
  func didReceiveMenu(_ menu: [Food]) {
    self.menuTodisplay = menu
  }
  
  func didReceiveMenyTypes(_ types: [String]) {
    self.menuTypes = types
  }
}
