//
//  MenuListViewController.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 29/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit


class MenuListViewController<Cell: FoodCell>: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
   
    var menyList: [Food]?
    var chosenMenu: Food?{
           didSet{
            // Gets a reference to the instance of ChosenMenuViewController that is inside tabBarController.
            let chosenMenuVC = tabBarController!.viewControllers![2] as? ChosenMenuViewController
            chosenMenuVC!.chosenMenu = chosenMenu
            let tabBarVC = tabBarController as! TabBarViewController
            tabBarVC.addBadgeViewAt(position: 3)
       }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menyList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let identifier = Cell.identifier
         guard  let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell
           else {fatalError("Cell Not Found")}
          cell.populateLabelsWith(menyList![indexPath.row])
           
          return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let name = menyList![indexPath.row].name
        let description = menyList![indexPath.row].description
        let price = menyList![indexPath.row].price
        chosenMenu = Food(name: name, price: price, description: description, image: "")
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    
}

class SandwichListController: MenuListViewController<SandwichCell> {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

class PizzaViewController: MenuListViewController<PizzaCell>{
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

