//
//  TrackerViewController.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 10/06/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

class TrackerViewController: UIViewController {
    
    @IBOutlet weak var orderTableview: UITableView!
    @IBOutlet weak var orderTitle: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantAdress: UILabel!
    @IBOutlet weak var trackerView: TrackerView!
    @IBOutlet weak var makeTheOrder: UIButton!
    @IBOutlet weak var restaurantView: UIView!
    
    @IBOutlet weak var orderTableHeight: NSLayoutConstraint!
    
    @IBAction private func sendTheOrder(_ sender: Any) {
        
        trackerView.transform = CGAffineTransform(scaleX: 1, y: 0.01)
        UIView.animate(withDuration: 2.0,
                       animations: {
                        self.trackerView.isHidden = false
                        self.trackerView.transform = .identity
                       },
                       completion: nil)
    }
    
    var count = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTitle()
        settingTableviewHeight()
    }
    
    private func configureTitle(){
        
        let text = "You ordered \(count) item" + (count > 1 ? "s:" : ":")
        let customFont = UIFont(name: "Helvetica Neue", size: 22)
        let attributedString = NSMutableAttributedString(string: text,
                                                         attributes: [.font: customFont!])
        let color = UIColor.white
        attributedString.addAttributes([.foregroundColor: color],
                                       range: NSRange(location: 12, length: 1))
        orderTitle.attributedText = attributedString
    }
    
    private func settingTableviewHeight(){
        
        let multiplier = count < 2 ? count : 2
        orderTableHeight.constant = CGFloat(multiplier*100)
        view.layoutIfNeeded()
        orderTableview.reloadData()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        trackerView.layer.cornerRadius = 10
        orderTableview.layer.cornerRadius = 10
        restaurantView.layer.cornerRadius = 10
        insertMapButton()
        
        orderTableview.delegate = self
        orderTableview.dataSource = self
        settingTableviewHeight()
        configureTitle()
        
        let name = Orders.shared.restaurantName!
        let adresse = Orders.shared.restaurantAdress!
        count = Orders.shared.ordersList.count
        restaurantName.text = name
        restaurantAdress.text = adresse
        makeTheOrder.layer.cornerRadius = 20
        
        let closeButton = setupSubviews(controller: self)
        closeButton.addTarget(self,
                              action: #selector(dismissTrackView),
                              for:  .touchUpInside)
    }
    
    @objc private  func dismissTrackView(){
           let tabBarVC = tabBarController as! TabBarViewController
           tabBarVC.showAlert()
       }
    
    @objc private func initiateMap() {
       
        let storyboard = UIStoryboard(name: "Initial", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "mapViewScene") as! MapViewController
        let name = restaurantName.text!
        let address = restaurantAdress.text!
        controller.restaurant = Restaurant(name: name, adresse: address)
        controller.hideContinueBt = true
        //Global function
        let closeButton = setupSubviews(controller: controller, color: .black)
        closeButton.addTarget(self,
                              action: #selector(dismissMapView),
                              for:  .touchUpInside)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller,animated: true)
    }
    
    @objc private func dismissMapView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func insertMapButton(){
        let button = UIButton(type: .detailDisclosure)
        button.tintColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        restaurantView.addSubview(button)
        let trailing = button.trailingAnchor.constraint(equalTo: restaurantView.trailingAnchor, constant: -10)
        let centerY = button.centerYAnchor.constraint(equalTo: restaurantView.centerYAnchor, constant: 0)
        NSLayoutConstraint.activate([centerY, trailing])
        button.addTarget(self, action: #selector(initiateMap), for: .touchUpInside)
    }
}


extension TrackerViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return Orders.shared.ordersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = OrderCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OrderCell
        
        let order = Orders.shared.ordersList[indexPath.row]
        cell.populateLabelsWith(order)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            tableView.beginUpdates()
            Orders.shared.ordersList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            count -= 1
            tableView.endUpdates()
            self.settingTableviewHeight()
            self.configureTitle()
            }
    }
    
    
}
