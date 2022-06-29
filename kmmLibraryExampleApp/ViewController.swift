//
//  ViewController.swift
//  kmmLibraryExampleApp
//
//  Created by mkruk2 on 01/26/2022.
//  Copyright (c) 2022 mkruk2. All rights reserved.
//

import aa_multiplatform_lib
import UIKit

class ViewController: UIViewController,
                      UITableViewDelegate,
                      UITableViewDataSource,
                      UITextFieldDelegate,
                    // Add content listener
                      AdContentListener {

    var zoneView: UIView?

    var currentSuggestions: [Suggestion]?
    var resultListTableView = UITableView()
    var searchField = SearchTextFieldUI()
    var searchFieldText = ""

    var addButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.setTitle("add", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()

    var listItems = [String]() {
        didSet {
            resultListTableView.reloadData()
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)

        // Initialize a view with AAZoneView and zone id
        self.zoneView = AAZoneView(zoneId: "101930", contentListener: self).getZoneView()

        populateDefaultList()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        // Initialize a view with AAZoneView and zone id
        self.zoneView = AAZoneView(zoneId: "101930", contentListener: self).getZoneView()

        populateDefaultList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(addDetailedItemTapped(notification:)), name: NSNotification.Name(rawValue: "addDetailedListItem"), object: nil)

        view.backgroundColor = .white
        zoneView?.translatesAutoresizingMaskIntoConstraints = false
        self.definesPresentationContext = true
        searchField.delegate = self

        setupSearchBar()
        setupResultView()
    }

    override func viewDidAppear(_ animated: Bool) {
        if let zoneView = zoneView {
            view.addSubview(zoneView)
        }
        view.addSubview(searchField)
        view.addSubview(addButton)
        view.addSubview(resultListTableView)
        setupConstraints()
    }

    func setupConstraints() {
        var constraints = [NSLayoutConstraint]()

        // Set the zoneView constraints
        if let zoneView = zoneView {
            constraints.append(zoneView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0))
            constraints.append(zoneView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0))
            constraints.append(zoneView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0))
            constraints.append(zoneView.heightAnchor.constraint(equalToConstant: 120.0))
        }

        constraints.append(searchField.topAnchor.constraint(equalTo: zoneView?.bottomAnchor ?? view.topAnchor))
        constraints.append(searchField.leftAnchor.constraint(equalTo: zoneView?.leftAnchor ?? view.leftAnchor, constant: 10.0))
        constraints.append(searchField.widthAnchor.constraint(equalTo: zoneView?.widthAnchor ?? view.widthAnchor, multiplier: 0.80))
        constraints.append(searchField.heightAnchor.constraint(equalToConstant: 40.0))

        constraints.append(addButton.centerYAnchor.constraint(equalTo: searchField.centerYAnchor))
        constraints.append(addButton.leftAnchor.constraint(equalTo: searchField.rightAnchor, constant: -5.0))
        constraints.append(addButton.rightAnchor.constraint(equalTo: zoneView?.rightAnchor ?? view.rightAnchor, constant: -10.0))
        constraints.append(addButton.heightAnchor.constraint(equalTo: searchField.heightAnchor, constant: -5.0))

        constraints.append(resultListTableView.topAnchor.constraint(equalTo: searchField.bottomAnchor))
        constraints.append(resultListTableView.leftAnchor.constraint(equalTo: searchField.leftAnchor))
        constraints.append(resultListTableView.rightAnchor.constraint(equalTo: searchField.rightAnchor))
        constraints.append(resultListTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5))

        NSLayoutConstraint.activate(constraints)
    }

    func onContentAvailable(zoneId: String, content: AddToListContent) {
        let items = content.getItems()
        items.forEach { item in
            listItems.append(item.title)

            // Acknowledge the item(s) added to the list
            content.acknowledge()
        }
    }

    @objc func addButtonTapped() {
        if searchFieldText != "" {
            listItems.append(searchFieldText)

            // Manage list events
            AdAdaptedListManager().itemAddedToList(item: searchFieldText, list: "Main Grocery List")

            if let suggestions = currentSuggestions {
                for suggestion in suggestions {
                    if searchFieldText == suggestion.name {

                        // confirm keyword added to user's list
                        suggestion.selected()
                    }
                }
            }
        }
        searchFieldText = ""
        searchField.text = ""
    }

    @objc
    func addDetailedItemTapped(notification: NSNotification) {
        let itemTitle = notification.userInfo!["detailedItem"] as! String
        listItems.append(itemTitle)

        // Manage list events
        AdAdaptedListManager().itemAddedToList(item: itemTitle, list: "Main Grocery List")
    }

    private func setupSearchBar() {
        searchField.frame = CGRect(x: 10, y: 140, width: 200, height: 10)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.tintColor = .systemBlue
        searchField.placeholder = "Groceries I Need"
        searchField.autocapitalizationType = .none
    }

    private func setupResultView() {
        resultListTableView.translatesAutoresizingMaskIntoConstraints = false
        resultListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "aaCell")
        resultListTableView.dataSource = self
        resultListTableView.delegate = self
    }

    private func populateDefaultList() {
        listItems.append("Eggs")
        listItems.append("Bread")
    }
}

extension ViewController {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchFieldText = textField.text ?? ""
        let keywords = InterceptMatcher.shared.match(constraint: searchFieldText)
        for keyword in keywords {

            // confirm keyword suggested to user
            keyword.presented()
            currentSuggestions?.append(keyword)
            searchField.resultsList.append(keyword.name)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return listItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "aaCell", for: indexPath)
            if listItems.count >= 1 {
                cell.textLabel?.text = listItems[indexPath.row]
            }
            return cell
    }
}
