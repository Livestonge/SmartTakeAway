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
        guard let controller = self.tabBarController as? TabBarViewController else { return }
        let name = menyList![indexPath.row].name
        let description = menyList![indexPath.row].description
        let price = menyList![indexPath.row].price
        let food = Food(name: name, price: price, description: description, image: "")
        controller.didSelect(food)
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
  
    private func addBadgeView(){
      guard let ctrl = self.tabBarController as? TabBarViewController else {return}
      ctrl.addBadgeViewAt(position: 3)
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

