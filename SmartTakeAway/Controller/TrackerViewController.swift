//
//  TrackerViewController.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 10/06/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

class TrackerViewController: UIViewController {
    
//  MARK: Outlets
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
  
    var order: Order?
    var orderManager: OrderProvider?
    var orderObserver: OrderObservable?
  
//  MARK:  UIViewcontroller Methods
  
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
      
        orderManager = OrderManager(orderObserver: orderObserver!)
        orderManager?.delegate = self
      
        configureTitle()
        settingTableviewHeight()
        
        makeTheOrder.layer.cornerRadius = 20
        
        let closeButton = setupSubviews(controller: self)
        closeButton.addTarget(self,
                              action: #selector(dismissTrackView),
                              for:  .touchUpInside)
    }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.orderManager?.getMadeOrder()
      let name = order?.restaurantName
      let adresse = order?.restaurantAdress
      restaurantName.text = name
      restaurantAdress.text = adresse
  }
  
//    MARK: Objc Methods
  
    @objc private  func dismissTrackView(){
        self.showAlert()
       }
    
    @objc private func initiateMap() {
       
        let storyboard = UIStoryboard(name: "Initial", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "mapViewScene") as! MapViewController
        let name = self.order?.restaurantName ?? ""
        let address = self.order?.restaurantAdress ?? ""
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
  
  func showAlert(){
      
      let message = "Your order will be deleted!!!"
      let alert = UIAlertController(title: "Ooops", message: message, preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "Delete", style: .default){ _ in
        self.orderManager?.deleteOrder()
        self.tabBarController?.selectedIndex = 1
      }
      
      let regretAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      alert.addAction(alertAction)
      alert.addAction(regretAction)
      self.present(alert, animated: true)
  }
  private func configureTitle(){
      let count = self.order?.foodsList.count ?? 0
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
      let count = self.order?.foodsList.count ?? 0
      let multiplier = count < 2 ? count : 2
      orderTableHeight.constant = CGFloat(multiplier*100)
      view.layoutIfNeeded()
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
      return self.order?.foodsList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = OrderCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OrderCell
        
        let food = self.order?.foodsList[indexPath.row]
        cell.populateLabelsWith(food!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      
      let row = indexPath.row
        if editingStyle == .delete{
            tableView.beginUpdates()
            self.orderManager?.deleteFoodAt(row)
            tableView.deleteRows(at: [indexPath], with: .right)
            tableView.endUpdates()
            }
    }
}

// MARK: OrderProviderDelegate

extension TrackerViewController: OrderProviderDelegate{
  
  func didReceiveOrder(_ order: Order) {
    self.order = order
    self.orderTableview.reloadData()
    configureTitle()
    settingTableviewHeight()
  }
}
