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
    var makeTheOrder: UIButton!
  
  
//  MARK: Proprieties
  
    var foodList: [OrderedFood] = []
    var restaurant: Restaurant?
    var orderManager: OrderProvider!
    var orderObserver: OrderObservable?
    var foodData = [String: [OrderedFood]]()
    private var sectionStates: [Int : Bool] = [:]
  
//  MARK:  UIViewcontroller Methods
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        orderTableview.delegate = self
        orderTableview.dataSource = self
        setUpViews()
      
        orderManager = OrderManager(orderObserver: orderObserver!)
        orderManager?.delegate = self
    }
  
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.orderManager?.getMadeOrder()
     for key in 0..<orderTableview.numberOfSections {
       sectionStates[key] = false
     }
  }
  
//    MARK: Objc Methods
  
    @objc
    private func sendTheOrder(_ sender: Any) {
      orderManager.didValidateOrder()
    }
  
  @objc
  func didTapOnBt(sender: UIButton){
    let sectionIndex = sender.tag
    guard let boolean = sectionStates[sectionIndex] else { return }
    sectionStates[sectionIndex] = !boolean
    let section = IndexSet(integer: sectionIndex)
    orderTableview.reloadSections(section, with: .none)
  }
  
//  MARK: Methods
    private func setUpHeaderView(){
      let headerView = UIView(frame: CGRect(origin: .zero,
                                          size: CGSize(width: orderTableview.bounds.width,
                                                       height: 50)))
      let titleLabel = UILabel(frame: headerView.bounds)
      headerView.addSubview(titleLabel)
      titleLabel.attributedText = getAttributedStringFor("Overview", color: .black)
      titleLabel.textAlignment = .center
      orderTableview.tableHeaderView = headerView
    }
    
    private func setUpOrderButton(){
      self.makeTheOrder = UIButton()
      makeTheOrder.translatesAutoresizingMaskIntoConstraints = false
      self.view.addSubview(makeTheOrder)
      NSLayoutConstraint.activate([
        makeTheOrder.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        makeTheOrder.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
        makeTheOrder.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        makeTheOrder.heightAnchor.constraint(equalToConstant: 60),
        orderTableview.bottomAnchor.constraint(greaterThanOrEqualTo: makeTheOrder.topAnchor, constant: -10)
      ])
      makeTheOrder.backgroundColor = .orange
      makeTheOrder.layer.cornerRadius = 15
      makeTheOrder.addTarget(self,
                          action: #selector(sendTheOrder),
                          for: .touchUpInside)
      makeTheOrder.setAttributedTitle(self.getAttributedStringFor("Confirmed selected items",
                                                                  color: .white), for: .normal)
    }
    private func setUpViews(){
    setUpHeaderView()
    setUpOrderButton()
    }
  
    private func getAttributedStringFor(_ title: String, color: UIColor) -> NSAttributedString{
      let customFont = UIFont(name: "Helvetica Neue", size: 22)
      return NSAttributedString(string: title,
                                       attributes: [.font: customFont!,
                                                    .foregroundColor : color])
    }
  
  private func getFoodAt(indexPath: IndexPath) -> OrderedFood? {
    switch indexPath.section{
    case 1:
      return self.foodData["ToBeConfirmed"]?[indexPath.row]
    case 2:
      return self.foodData["Pending"]?[indexPath.row]
    case 3:
      return self.foodData["Done"]?[indexPath.row]
    default:
      return nil
    }
  }

}


extension TrackerViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
      switch section {
      case 0:
        return 1
      case 1:
        let list = self.foodData["ToBeConfirmed"]?.count ?? 0
        return  self.sectionStates[1] == false || list == 0 ? 0 : list
      case 2:
        return self.sectionStates[2] == false ? 0 : self.foodData["Pending"]?.count ?? 0
      case 3:
        return self.sectionStates[3] == false ? 0 : self.foodData["Done"]?.count ?? 0
      default:
         return 0
      }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = OrderCell.identifier
      
      switch indexPath.section{
      case 0:
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath)
        let attributedText = getAttributedStringFor(restaurant?.name ?? "",
                                                    color: .black)
        if #available(iOS 14, *){
          var content = cell.defaultContentConfiguration()
          content.attributedText = attributedText
          cell.contentConfiguration = content
          content.secondaryText = restaurant?.adresse
          cell.contentConfiguration = content
        }else{
          cell.textLabel?.attributedText = attributedText
          cell.detailTextLabel?.text = restaurant?.adresse
        }
        return cell
      case 1:
        let food = self.foodData["ToBeConfirmed"]?[indexPath.row]
        let orderCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OrderCell
        orderCell.populateLabelsWith(food!)
        return orderCell
      case 2:
        let food = self.foodData["Pending"]?[indexPath.row]
        let orderCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OrderCell
        orderCell.populateLabelsWith(food!)
        return orderCell
      case 3:
        let food = self.foodData["Done"]?[indexPath.row]
        let orderCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OrderCell
        orderCell.populateLabelsWith(food!)
        return orderCell
      default:
         break
      }
        fatalError("Failed to load the tableview cell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
  
    func numberOfSections(in tableView: UITableView) -> Int {
      return self.foodData.keys.count + 1
    }
    
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let view = UIView()
    let titleLabel = UILabel()
    var count = 0
    switch section{
    case 1:
      count = self.foodData["ToBeConfirmed"]?.count ?? 0
    case 2:
      count = self.foodData["Pending"]?.count ?? 0
    case 3:
      count = self.foodData["Done"]?.count ?? 0
    default:
      break
    }
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(titleLabel)
    let button = UIButton(type: .detailDisclosure)
    button.tag = section
    let image = sectionStates[section] == false ? UIImage(systemName: "chevron.right") : UIImage(systemName: "chevron.down")
    
    if count > 0{
      button.setImage(image, for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.addTarget(self,
                       action: #selector(didTapOnBt(sender:)),
                       for: .touchUpInside)
      view.addSubview(button)
      NSLayoutConstraint.activate([
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      ])
    }
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
    ])
    
    view.layer.cornerRadius = 10
    switch section{
    case 1:
      titleLabel.text = "\(count) Selected food"
    case 2:
      titleLabel.text = "\(count) under preparation"
    case 3:
      titleLabel.text = "\(count) finished"
    default:
      return nil
    }
    view.backgroundColor = .yellow
    return view
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0{
      return 20
    }
    return 50
  }

    
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    guard let food = getFoodAt(indexPath: indexPath) else { return }
    self.orderManager.delete(food)
    self.orderManager.getMadeOrder()
  }
}

// MARK: OrderProviderDelegate

extension TrackerViewController: OrderProviderDelegate{
  
  func didReceiveFood(_ list: [OrderedFood], withStatus: OrderStatus) {
    
    switch withStatus {
    case .preparation:      
      self.foodData["Pending"] = list
    case .finished:
      self.foodData["Done"] = list
    case .toBeConfirmed:
      self.foodData["ToBeConfirmed"] = list
    }
    
    self.orderTableview.reloadData()
    self.makeTheOrder.isHidden = foodData["ToBeConfirmed"]?.count == 0 ? true : false
    
  }
  
  func didReceiveRestaurant(_ restaurant: Restaurant) {
    self.restaurant = restaurant
  }
  
  func showAlertWith(message: String) {
    let alert = UIAlertController(title: "OOPS",
                                  message: message,
                                  preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: nil)
    
    alert.addAction(defaultAction)
    self.present(alert,
                 animated: true)
  }
}
