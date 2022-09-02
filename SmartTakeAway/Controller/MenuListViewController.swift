//
//  MenuListViewController.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 29/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

// Generic ViewController for group the common fonctionnalities of sandwich and pizza viewControllers.
class MenuListViewController<Cell: FoodCell>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Proprieties

    // Variable for holding the list of food to display.
    var menyList: [Food]?
    // Variable for holding the action to execute when the user complete selection.
    var didCompleteSelectingWith: ((SelectedFood) -> Void)?
    // ViewController to display modally when the user selects a food.
    var newViewController: SelectionViewController {
        let storyboard = UIStoryboard(name: "Initial", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "NewStorybaord") as! SelectionViewController
        return viewController
    }

    // MARK: Tableview Protocols Conformances

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return menyList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = Cell.identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell
        else { fatalError("Cell Not Found") }
        // Populate the appropriate cell dynamically using the generic Cell.
        cell.populateLabelsWith(menyList![indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row.
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class SandwichListController: MenuListViewController<SandwichCell> {
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let food = menyList?[indexPath.row] else { return }
        // Instantiate the newViewController instance.
        let ctrl = newViewController
        // inject the didCompleteSelection variable and the selected food.
        ctrl.didCompleteSelection = didCompleteSelectingWith
        ctrl.chosenFood = SelectedFood(type: "Sandwich",
                                       food: food)
        present(ctrl, animated: true)
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}

class PizzaViewController: MenuListViewController<PizzaCell> {
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: Tableview Protocols Conformances

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Retrieve the corresponding food from the list.
        guard let food = menyList?[indexPath.row] else { return }

        // Instantiate the newViewController instance.
        let ctrl = newViewController
        // inject the didCompleteSelection variable and the selected food.
        ctrl.didCompleteSelection = didCompleteSelectingWith
        ctrl.chosenFood = SelectedFood(type: "Pizza",
                                       food: food)
        present(ctrl, animated: true)
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}
