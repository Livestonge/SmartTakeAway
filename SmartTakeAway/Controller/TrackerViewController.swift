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

    @IBOutlet var orderTableview: UITableView!
    var makeTheOrder: UIButton!

    //  MARK: Proprieties

    //  Propriety for holding the user's ordered food.
    var foodList: [OrderedFood] = []
    //  The selected restaurant.
    var restaurant: Restaurant?
    // Objects for handling the current order.
    var orderManager: OrderProvider!
    var orderObserver: OrderObservable?
    // Variable for holding the ordered food based on their status.
    var foodData = [String: [OrderedFood]]()
    private var sectionStates: [Int: Bool] = [:]

    //  MARK: UIViewcontroller Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        orderTableview.delegate = self
        orderTableview.dataSource = self
        setUpViews()

        // Variable initialization
        orderManager = OrderManager(orderObserver: orderObserver!)
        orderManager?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // fetch ordered foods.
        orderManager?.getTheListOfFood()
        orderManager.willShowOrderPage()

        for key in 0 ..< orderTableview.numberOfSections {
            sectionStates[key] = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        orderManager.orderPageWillDisappear()
    }

//    MARK: Objc Methods

    @objc
    private func sendTheOrder(_: Any) {
        // Called when the user validate an order
        orderManager.didValidateOrder()
    }

    // Called when the user tap on the disclosure function.
    @objc
    func didTapOnBt(sender: UIButton) {
        let sectionIndex = sender.tag
        guard let boolean = sectionStates[sectionIndex] else { return }
        // Toggle the state of the section index.
        sectionStates[sectionIndex] = !boolean
        let section = IndexSet(integer: sectionIndex)
        orderTableview.reloadSections(section, with: .none)
    }

    //  MARK: Methods

    private func setUpHeaderView() {
        let headerView = UIView(frame: CGRect(origin: .zero,
                                              size: CGSize(width: orderTableview.bounds.width,
                                                           height: 50)))
        let titleLabel = UILabel(frame: headerView.bounds)
        headerView.addSubview(titleLabel)
        titleLabel.attributedText = getAttributedStringFor("Overview", color: .black)
        titleLabel.textAlignment = .center
        orderTableview.tableHeaderView = headerView
    }

//    Add an order button to the view.
    private func setUpOrderButton() {
        makeTheOrder = UIButton()
        makeTheOrder.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(makeTheOrder)
        NSLayoutConstraint.activate([
            makeTheOrder.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            makeTheOrder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            makeTheOrder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            makeTheOrder.heightAnchor.constraint(equalToConstant: 60),
            orderTableview.bottomAnchor.constraint(greaterThanOrEqualTo: makeTheOrder.topAnchor, constant: -10),
        ])
        makeTheOrder.backgroundColor = .orange
        makeTheOrder.layer.cornerRadius = 15
        makeTheOrder.addTarget(self,
                               action: #selector(sendTheOrder),
                               for: .touchUpInside)
        makeTheOrder.setAttributedTitle(getAttributedStringFor("Confirmed selected items",
                                                               color: .white), for: .normal)
    }

    private func setUpViews() {
        setUpHeaderView()
        setUpOrderButton()
    }

    // Initiating an instance of NSAttributedString based on passed parameters.
    private func getAttributedStringFor(_ title: String, color: UIColor) -> NSAttributedString {
        let customFont = UIFont(name: "Helvetica Neue", size: 22)
        return NSAttributedString(string: title,
                                  attributes: [.font: customFont!,
                                               .foregroundColor: color])
    }

    // Fetching an orderedFood based on the current indexpath.
    private func getFoodAt(indexPath: IndexPath) -> OrderedFood? {
        switch indexPath.section {
        case 1:
            return foodData["ToBeConfirmed"]?[indexPath.row]
        case 2:
            return foodData["Pending"]?[indexPath.row]
        case 3:
            return foodData["Done"]?[indexPath.row]
        default:
            return nil
        }
    }
}

extension TrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The returned number of rows depends on the value of sectionStates[section]
        switch section {
        case 0:
            return 1
        case 1:
            let list = foodData["ToBeConfirmed"]?.count ?? 0
            return sectionStates[1] == false || list == 0 ? 0 : list
        case 2:
            return sectionStates[2] == false ? 0 : foodData["Pending"]?.count ?? 0
        case 3:
            return sectionStates[3] == false ? 0 : foodData["Done"]?.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = OrderCell.identifier

        switch indexPath.section {
        case 0:

            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath)
            let attributedText = getAttributedStringFor(restaurant?.name ?? "",
                                                        color: .black)
            if #available(iOS 14, *) {
                var content = cell.defaultContentConfiguration()
                content.attributedText = attributedText
                cell.contentConfiguration = content
                content.secondaryText = restaurant?.adresse
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.attributedText = attributedText
                cell.detailTextLabel?.text = restaurant?.adresse
            }
            return cell
        case 1:
            let food = foodData["ToBeConfirmed"]?[indexPath.row]
            let orderCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OrderCell
            orderCell.populateLabelsWith(food!)
            return orderCell
        case 2:
            let food = foodData["Pending"]?[indexPath.row]
            let orderCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OrderCell
            orderCell.populateLabelsWith(food!)
            return orderCell
        case 3:
            let food = foodData["Done"]?[indexPath.row]
            let orderCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OrderCell
            orderCell.populateLabelsWith(food!)
            return orderCell
        default:
            break
        }
        fatalError("Failed to load the tableview cell")
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 100
    }

    func numberOfSections(in _: UITableView) -> Int {
        return foodData.keys.count + 1
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // HeaderView
        let view = UIView()
        // TitleLabel
        let titleLabel = UILabel()
        // Variable for reading the count of each category.
        var count = 0
        switch section {
        case 1:
            count = foodData["ToBeConfirmed"]?.count ?? 0
        case 2:
            count = foodData["Pending"]?.count ?? 0
        case 3:
            count = foodData["Done"]?.count ?? 0
        default:
            break
        }
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        // Disclosure button.
        let button = UIButton(type: .detailDisclosure)
        button.tag = section
        let image = sectionStates[section] == false ? UIImage(systemName: "chevron.right") : UIImage(systemName: "chevron.down")

        if count > 0 {
            button.setImage(image, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self,
                             action: #selector(didTapOnBt(sender:)),
                             for: .touchUpInside)
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
        }
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
        ])

        view.layer.cornerRadius = 10
        switch section {
        case 1:
            titleLabel.text = "\(count) Selected food"
        case 2:
            titleLabel.text = "\(count) under preparation"
        case 3:
            titleLabel.text = "\(count) finished, enjoy your meals"
        default:
            return nil
        }
        view.backgroundColor = .yellow
        return view
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 50
    }

    func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Notifies the manager that the user wants to delete.
        if editingStyle == .delete {
            guard let food = getFoodAt(indexPath: indexPath) else { return }
            orderManager.delete(food)
            orderManager.getTheListOfFood()
        }
    }
}

// MARK: OrderProviderDelegate

extension TrackerViewController: OrderProviderDelegate {
    func didReceiveFood(_ list: [OrderedFood], withStatus: OrderStatus) {
        // Filling th data dictionnary depending on the parameter withStatus.
        switch withStatus {
        case .preparation:
            foodData["Pending"] = list
        case .finished:
            foodData["Done"] = list
        case .toBeConfirmed:
            foodData["ToBeConfirmed"] = list
        }

        orderTableview.reloadData()
        // The button disappears if there is no food to confirme.
        makeTheOrder.isHidden = foodData["ToBeConfirmed"]?.count == 0 ? true : false
    }

    func didReceiveRestaurant(_ restaurant: Restaurant) {
        // The restaurant associated with the current command.
        self.restaurant = restaurant
    }

    func showAlertWith(message: String) {
        // Alert to show in case the user tries to delete a food in preparation.
        let alert = UIAlertController(title: "OOPS",
                                      message: message,
                                      preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK",
                                          style: .cancel,
                                          handler: nil)

        alert.addAction(defaultAction)
        present(alert,
                animated: true)
    }
}
