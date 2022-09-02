//
//  FoodViewController.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 20/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController {
    // MARK: IBOutlet

    // View used as a placeholder for the different viewcontrollers.
    @IBOutlet var containerView: UIView!
    // Switching between the different viewControllers
    @IBOutlet var menuTypeSegmentCtrl: UISegmentedControl!

    // MARK: Proprieties

    // Variable to display the list of food.
    private var menuTodisplay: [Food] = []
    // Object providing the list of food.
    private var menuProvider: MenuProvider?
    // A variable holding the different types of food.
    private var menuTypes: [String] = []
    // A variable for the sandwichViewController.
    private var sandwichCtrl: SandwichListController?
    // A variable for the action to execute when the user complete his selection.
    var didCompleteSelection: ((SelectedFood) -> Void)?
    // A variable for the pizzaViewController.
    lazy var pizzaViewController: PizzaViewController = {
        let storyboard = UIStoryboard(name: "Pizza", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "pizzaStoryboard") as! PizzaViewController
        viewController.didCompleteSelectingWith = didCompleteSelectionWith
        return viewController
    }()

    // MARK: ViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Choose a menu"

        // Dependencies injections
        menuProvider = MenuProviding()
        menuProvider?.delegate = self
        menuProvider?.getMenuFor(.sandwiches)
        menuProvider?.getMenyTypes()
        sandwichCtrl?.menyList = menuTodisplay

        // menuTypeSegmentController configuration.
        menuTypeSegmentCtrl.backgroundColor = .white
        menuTypeSegmentCtrl.selectedSegmentTintColor = .orange
        menuTypeSegmentCtrl.removeAllSegments()
        menuTypeSegmentCtrl.addTarget(self,
                                      action: #selector(didSelectSegment),
                                      for: .valueChanged)
        // Filling the controller with the content of menuTypes variable.
        for (index, title) in menuTypes.enumerated() {
            menuTypeSegmentCtrl.insertSegment(withTitle: title,
                                              at: index,
                                              animated: true)
        }
        // Sets the sandwich Controller as the default or initial selection.
        menuTypeSegmentCtrl.selectedSegmentIndex = menuTypes.firstIndex(of: "Sandwiches") ?? 0
    }

    // Use this method to inject the didCompleteSelection closure to sandwichCtrl.
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "foodSegue" {
            sandwichCtrl = segue.destination as? SandwichListController
            sandwichCtrl?.didCompleteSelectingWith = didCompleteSelectionWith
        }
    }

    // Wrapper for the didCompleteSelection variable.
    private func didCompleteSelectionWith(food: SelectedFood) {
        didCompleteSelection?(food)
    }

    //  MARK: Objc

    @objc
    // Method called when the user taps on the segmented controller.
    func didSelectSegment() {
        // Read the index of the current selection.
        let index = menuTypeSegmentCtrl.selectedSegmentIndex
        // Retrieve the title of the selected segment
        let title = menuTypeSegmentCtrl.titleForSegment(at: index)
        if title == "Sandwiches" {
            pizzaViewController.removeFromParent()
            pizzaViewController.view.removeFromSuperview()
            // Gets from the provider the menu for sandwich type.
            menuProvider?.getMenuFor(.sandwiches)
        } else if title == "Pizza" {
            // Gets from the provider the menu for sandwich type.
            menuProvider?.getMenuFor(.pizza)
            // Injects the menuList.
            pizzaViewController.menyList = menuTodisplay
            // Add the pizzaCtrl to the current viewController.
            addChild(pizzaViewController)
            // Pushing the pizzaViewController´s view on top of the sandwichController`s view.
            view.addSubView(view: pizzaViewController.view, constraintTo: containerView)
            view.bringSubviewToFront(menuTypeSegmentCtrl)
        } else {
            // if the title don't correspond to any of above, an alert is shown.
            let alert = UIAlertController(title: "Burger", message: "Burger menu not available😔", preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OK)
            present(alert, animated: true)
        }
    }
}

// MARK: MenuProviderDelegate Conformance.

extension FoodViewController: MenuProviderDelegate {
    func didReceiveMenu(_ menu: [Food]) {
        // Updates the menuToDisplay variable with received data.
        menuTodisplay = menu
    }

    func didReceiveMenyTypes(_ types: [String]) {
        // Updates the menuTypes variable with received data.
        menuTypes = types
    }
}
