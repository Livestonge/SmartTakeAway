//
//  NewViewController.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 05/08/2022.
//

import UIKit

class SelectionViewController: UIViewController {
    //  MARK: Outlets

    @IBOutlet var foodTableview: UITableView!
    @IBOutlet var foodImageView: UIImageView!

    //  MARK: Proprieties

    //  Propriety for the state of the disclosure button in each section.
    private var sectionStates: [Int: Bool] = [:]
    // Propriety used to define dynamically the height of a tableviewCell.
    private var label: UILabel?
    // Propriety for holding user 's selections of accessories.
    private var userSelection: UserSelection?
    // Object for managing the business logic of selecting an accessory.
    var manager: FoodSelectionManager?
    // Selected food
    var chosenFood: SelectedFood?

    //  Object handling app usage analytics.
    lazy var analyticsManager = FirebaseManager()
    // Accessories provider
    var foodAccessoryProvider: FoodAccessoryProvider?
    // Propriety holding the accessories to display
    var data: [String: [String]] = [:]
    // Action to execute when the user make the final selection.
    var didCompleteSelection: ((SelectedFood) -> Void)?

    //  MARK: ViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        foodTableview.delegate = self
        foodTableview.dataSource = self
        // For the case when the user can make 2 selections.
        foodTableview.allowsMultipleSelection = true

        // Propriety initialisation
        manager = FoodSelectionManager()
        foodAccessoryProvider = FoodAccessoryProviding(foodType: chosenFood?.type ?? "")
        foodAccessoryProvider?.delegate = self
        foodAccessoryProvider?.getFoodAccessories()
        manager?.delegate = self
        let imageString = chosenFood?.imagePath ?? ""
        foodImageView.image = UIImage(named: imageString)
        // define the initial state of each disclosure button in each section
        for key in 0 ..< foodTableview.numberOfSections {
            sectionStates[key] = false
        }
        setUpViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Tracking the selected food.
        analyticsManager.didSelectFood(chosenFood)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Nullify the closure when the view disappear.
        didCompleteSelection = nil
    }

    //  MARK: Custom methods

    // Adding addButton and close button.
    private func setUpViews() {
        foodTableview.translatesAutoresizingMaskIntoConstraints = false
        let addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        addButton.setTitle("Add", for: .normal)
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            foodTableview.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: 0),
        ])
        addButton.backgroundColor = .orange
        addButton.layer.cornerRadius = 15
        addButton.addTarget(self,
                            action: #selector(didTapAddBt),
                            for: .touchUpInside)

        let closeButton: UIButton = CloseButton(crossColor: .orange)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 25),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
        ])
        closeButton.layer.cornerRadius = closeButton.bounds.width / 2
        closeButton.addTarget(self,
                              action: #selector(didTapCloseBt),
                              for: .touchUpInside)
    }

    // Alert to show when the user did not choose accessories.
    private func showAlert() {
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
        present(alert,
                animated: true)
    }

    //  MARK: Objc.

    @objc
    func didTapCloseBt() {
        dismiss(animated: true)
    }

    @objc
    func didTapAddBt() {
        if userSelection == nil {
            showAlert()
            return
        }
        // Update the selected food with the user selected accessories.
        chosenFood?.updateAcessories(userSelection: userSelection!)
        // Execute the closure with the selected food as argument
        didCompleteSelection?(chosenFood!)
        dismiss(animated: true)
    }

    @objc
    func didTapOnBt(sender: UIButton) {
        let sectionIndex = sender.tag
        guard let boolean = sectionStates[sectionIndex] else { return }
        // Toggle the state of the section index.
        sectionStates[sectionIndex] = !boolean
        let section = IndexSet(integer: sectionIndex)
        foodTableview.reloadSections(section, with: .none)
    }
}

// MARK: Tableview Delegate conformance

extension SelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return data.keys.count + 1
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The returned number of rows depends on the value of sectionStates[section]
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
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThisIsFoodCell", for: indexPath) as? NewFoodDetailCellTableViewCell else { fatalError("Failed to load cell") }
            cell.foodTitle.text = chosenFood?.name ?? ""
            label = cell.foodDetailDescription
            cell.foodDetailDescription.text = chosenFood?.description ?? ""
            cell.foodPrice.text = "\(chosenFood?.price ?? 0) €"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThisIsDetailCell", for: indexPath)
            let text = data["Drinks"]?[indexPath.row] ?? ""

            if #available(iOS 14, *) {
                var content = cell.defaultContentConfiguration()
                content.text = text
                cell.contentConfiguration = content
                // if the current indexPath is equal to the id of the accessory then we set to checkmark else none.
                cell.accessoryType = self.userSelection?.drink?.id == indexPath.row ? .checkmark : .none
            } else {
                cell.textLabel?.text = text
            }

            cell.accessoryType = userSelection?.drink?.id == indexPath.row ? .checkmark : .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThisIsDetailCell", for: indexPath)
            let text = data["Sauces"]?[indexPath.row] ?? ""
            if #available(iOS 14, *) {
                var content = cell.defaultContentConfiguration()
                content.text = text
                cell.contentConfiguration = content
                // if the current indexPath is equal to the id of the accessory then we set to checkmark else none.
                cell.accessoryType = self.userSelection?.drink?.id == indexPath.row ? .checkmark : .none
            } else {
                cell.textLabel?.text = text
            }
            // if the current indexPath is equal to the id of the accessory then we set to checkmark else none.
            let id_0 = userSelection?.sauces.0?.id
            let id_1 = userSelection?.sauces.1?.id
            cell.accessoryType = [id_0, id_1].contains(indexPath.row) ? .checkmark : .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThisIsDetailCell", for: indexPath)
            let text = data["Taille"]?[indexPath.row] ?? ""
            if #available(iOS 14, *) {
                var content = cell.defaultContentConfiguration()
                content.text = text
                cell.contentConfiguration = content
                // if the current indexPath is equal to the id of the accessory then we set to checkmark else none.
                cell.accessoryType = self.userSelection?.drink?.id == indexPath.row ? .checkmark : .none
            } else {
                cell.textLabel?.text = text
            }
            // if the current indexPath is equal to the id of the accessory then we set to checkmark else none.
            cell.accessoryType = userSelection?.size?.id == indexPath.row ? .checkmark : .none
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        var accessory: Accessory?

        switch indexPath.section {
        case 1:
            let drink = data["Drinks"]?[indexPath.row]
            // When the user selects a cell then we create an accessory which has as Id the current indexpath.
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
        // Notifies the manager of the current user selection.
        manager?.didSelect(accessory!)
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            // Read the label height
            let height = label?.intrinsicContentSize.height ?? 0
            let cellHeight = 80 + height
            // Sets the height of row depending of the label height.
            return cellHeight > 90 ? cellHeight : 90
        default:
            return 50
        }
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 150
        }
        return 50
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Making header view for each section.
        let view = UIView()
        // Add a label to the header view.
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        // Add a disclosure button.
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
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        view.layer.cornerRadius = 10
        switch section {
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
}

// MARK: NewManagerDelegate conformance

extension SelectionViewController: AccessoriesManagerDelegate {
    func didReceive(selection: UserSelection) {
        userSelection = selection
        foodTableview.reloadData()
    }
}

// MARK: FoodAccessoryProviderDelegate conformance

extension SelectionViewController: FoodAccessoryProviderDelegate {
    func didReceiveDrinkList(_ drinks: [String]) {
        // Adding the received accessories to the data dictionnary.
        data["Drinks"] = drinks
        foodTableview.reloadData()
    }

    func didReceiveSausList(_ saus: [String]) {
        data["Sauces"] = saus
        foodTableview.reloadData()
    }

    func didReceiveTaille(_ taille: [String]) {
        data["Taille"] = taille
        foodTableview.reloadData()
    }
}
