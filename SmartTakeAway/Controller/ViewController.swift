//
//  ViewController.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 13/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    lazy var restaurantList: [Restaurant] = {
        let restaurants = StoredData<[Restaurant]>(fileName: "Restaurants")
        return restaurants.model ?? []
    }()
   
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.barTintColor = .orange
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.orange]
        navigationItem.title = "Choose your restaurant"
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "transitionToMapView"{

            if let destination = segue.destination as? MapViewController,
                let indexPath = tableView.indexPathForSelectedRow{
                destination.restaurant = restaurantList[indexPath.row]
            }
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let name = restaurantList[indexPath.row].name
        let titleFont = UIFont(name: "ArialRoundedMTBold", size: 22)
        let attributedtext = NSAttributedString(string: name,
                                                attributes: [NSAttributedString.Key.font: titleFont!])
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "customCell")
        cell.textLabel?.attributedText = attributedtext
        let adresse = restaurantList[indexPath.row].adresse
        cell.detailTextLabel?.text = "📍 \(adresse)"
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
        self.performSegue(withIdentifier: "transitionToMapView", sender: nil)
    }
    
    
}
