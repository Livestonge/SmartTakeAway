//
//  NewViewController.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 05/08/2022.
//

import UIKit

class SelectionViewController: UIViewController {

  @IBOutlet weak var foodTableview: UITableView!
  @IBOutlet weak var foodImageView: UIImageView!
  
  private var sectionStates: [Int : Bool] = [:]
  private var label: UILabel?
  private var userSelection: UserSelection?
  var manager: FoodSelectionManager?
  var chosenFood: SelectedFood?
  lazy var analyticsManager = FirebaseManager()
  var foodAccessoryProvider: FoodAccessoryProvider?
  var data: [String : [String]] = [:]
  var didCompleteSelection: ((SelectedFood) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    foodTableview.delegate = self
    foodTableview.dataSource = self
    foodTableview.allowsMultipleSelection = true
    
    manager = FoodSelectionManager()
    foodAccessoryProvider = FoodAccessoryProviding(foodType: chosenFood?.type ?? "")
    foodAccessoryProvider?.delegate = self
    foodAccessoryProvider?.getFoodAccessories()
    manager?.delegate = self
    let imageString = self.chosenFood?.imagePath ?? ""
    foodImageView.image = UIImage(named: imageString)
    for key in 0..<foodTableview.numberOfSections {
      sectionStates[key] = false
    }
    setUpViews()
    }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    analyticsManager.didSelectFood(chosenFood)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    didCompleteSelection = nil
  }
  
  private func setUpViews(){
    foodTableview.translatesAutoresizingMaskIntoConstraints = false
    let addButton = UIButton()
    addButton.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(addButton)
    addButton.setTitle("Add", for: .normal)
    NSLayoutConstraint.activate([
      addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      addButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
      addButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      addButton.heightAnchor.constraint(equalToConstant: 60),
      foodTableview.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: 0)
    ])
    addButton.backgroundColor = .orange
    addButton.layer.cornerRadius = 15
    addButton.addTarget(self,
                        action: #selector(didTapAddBt),
                        for: .touchUpInside)
    
    let closeButton: UIButton = CloseButton(crossColor: .orange)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(closeButton)
    NSLayoutConstraint.activate([
      closeButton.heightAnchor.constraint(equalToConstant: 25),
      closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
      closeButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10)
    ])
    closeButton.layer.cornerRadius = closeButton.bounds.width/2
    closeButton.addTarget(self,
                          action: #selector(didTapCloseBt),
                          for: .touchUpInside)
  }
  
  @objc
  func didTapCloseBt(){
    self.dismiss(animated: true)
  }
  
  @objc
  func didTapAddBt(){
    if self.userSelection == nil{
      showAlert()
      return
    }
    chosenFood?.updateAcessories(userSelection: userSelection!)
    didCompleteSelection?(chosenFood!)
    self.dismiss(animated: true)
  }
  
  private func showAlert(){
    let alert = UIAlertController(title: "Oops",
                                  message: "You did not choose drink nor sauces",
                                  preferredStyle: .alert)
    let continuAction = UIAlertAction(title: "Continue",
                                      style: .default,
                                      handler: { _ in
                                        self.chosenFood?.updateAcessories(userSelection: UserSelection())
                                        self.didCompleteSelection?(self.chosenFood!)
                                        self.dismiss(animated: true)
                                      })
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .cancel,
                                     handler: nil)
    alert.addAction(continuAction)
    alert.addAction(cancelAction)
    self.present(alert,
                 animated: true)
  }
}


extension SelectionViewController: UITableViewDelegate, UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return data.keys.count + 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return sectionStates[1] == false ? 0 : data["Drinks"]?.count ?? 0
    case 2:
      return sectionStates[2] == false ? 0 : data["Sauces"]?.count ?? 0
    case 3:
      return sectionStates[3] == false ? 0 : data["Taille"]?.count ?? 0
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section{
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThisIsFoodCell", for: indexPath) as? NewFoodDetailCellTableViewCell else { fatalError("Failed to load cell")}
      cell.foodTitle.text = chosenFood?.name ?? ""
      self.label = cell.foodDetailDescription
      cell.foodDetailDescription.text = self.chosenFood?.description ?? ""
      cell.foodPrice.text = "\(chosenFood?.price ?? 0) €"
      return cell
    case 1 :
      let cell = tableView.dequeueReusableCell(withIdentifier: "ThisIsDetailCell", for: indexPath)
      let text = data["Drinks"]?[indexPath.row] ?? ""
      
      if #available(iOS 14, *){
        var content = cell.defaultContentConfiguration()
        content.text = text
        cell.contentConfiguration = content
        cell.accessoryType = self.userSelection?.drink?.id == indexPath.row ? .checkmark : .none
      }else{
        cell.textLabel?.text = text
      }
      
      cell.accessoryType = self.userSelection?.drink?.id == indexPath.row ? .checkmark : .none
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "ThisIsDetailCell", for: indexPath)
      let text = data["Sauces"]?[indexPath.row] ?? ""
      if #available(iOS 14, *){
        var content = cell.defaultContentConfiguration()
        content.text = text
        cell.contentConfiguration = content
        cell.accessoryType = self.userSelection?.drink?.id == indexPath.row ? .checkmark : .none
      }else{
        cell.textLabel?.text = text
      }
      
      let id_0 = self.userSelection?.sauces.0?.id
      let id_1 = self.userSelection?.sauces.1?.id
      cell.accessoryType = [id_0, id_1].contains(indexPath.row) ? .checkmark : .none
      return cell
    case 3:
      let cell = tableView.dequeueReusableCell(withIdentifier: "ThisIsDetailCell", for: indexPath)
      let text = data["Taille"]?[indexPath.row] ?? ""
      if #available(iOS 14, *){
        var content = cell.defaultContentConfiguration()
        content.text = text
        cell.contentConfiguration = content
        cell.accessoryType = self.userSelection?.drink?.id == indexPath.row ? .checkmark : .none
      }else{
        cell.textLabel?.text = text
      }
      
      cell.accessoryType = self.userSelection?.size?.id == indexPath.row ? .checkmark : .none
      return cell
    default:
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var accessory: Accessory?
    
    switch indexPath.section{
    case 1:
      let drink = data["Drinks"]?[indexPath.row]
      accessory = Accessory(id: indexPath.row,
                                type: "Drink",
                                name: drink!)
      chosenFood?.updatePriceWith()
    case 2:
      let sauce = data["Sauces"]?[indexPath.row]
      accessory = Accessory(id: indexPath.row,
                                type: "Sauce",
                                name: sauce!)
      chosenFood?.updatePriceWith()
    case 3:
      let size = data["Taille"]?[indexPath.row]
      chosenFood?.updatePriceWith(indexPath.row)
      accessory = Accessory(id: indexPath.row,
                            type: "Taille",
                            name: size!)
    default: break
    }
    manager?.didSelect(accessory!)
  }
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section{
    case 0:
      let height = label?.intrinsicContentSize.height ?? 0
      let cellHeight = 80 + height
      return  cellHeight > 90 ? cellHeight : 90
    default:
      return 50
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 150
    }
    return 50
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let view = UIView()
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(titleLabel)
    let button = UIButton(type: .detailDisclosure)
    button.tag = section
    let image = sectionStates[section] == false ? UIImage(systemName: "chevron.right") : UIImage(systemName: "chevron.down")
    
    button.setImage(image, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self,
                     action: #selector(didTapOnBt(sender:)),
                     for: .touchUpInside)
    view.addSubview(button)
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
      button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    view.layer.cornerRadius = 10
    switch section{
    case 1:
      titleLabel.text = "Boisson"
    case 2:
      titleLabel.text = "Sauce"
    case 3:
      titleLabel.text = "Taille"
    default:
      return nil
    }
    view.backgroundColor = .yellow
    return view
  }
  
  @objc
  func didTapOnBt(sender: UIButton){
    let sectionIndex = sender.tag
    guard let boolean = sectionStates[sectionIndex] else { return }
    sectionStates[sectionIndex] = !boolean
    let section = IndexSet(integer: sectionIndex)
    foodTableview.reloadSections(section, with: .none)
  }
}

extension SelectionViewController: NewManagerDelegate{
  func didReceive(selection: UserSelection) {
    self.userSelection = selection
    foodTableview.reloadData()
  }
  
}

extension SelectionViewController: FoodAccessoryProviderDelegate{
  func didReceiveDrinkList(_ drinks: [String]) {
    self.data["Drinks"] = drinks
    self.foodTableview.reloadData()
  }
  
  func didReceiveSausList(_ saus: [String]) {
    self.data["Sauces"] = saus
    self.foodTableview.reloadData()
  }
  
  func didReceiveTaille(_ taille: [String]) {
    self.data["Taille"] = taille
    self.foodTableview.reloadData()
  }
  
}
