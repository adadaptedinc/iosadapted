//
//  SearchTextFieldUI.swift
//  kmmLibraryExampleApp
//
//  Created by Matthew Kruk on 5/30/22.
//

import UIKit

class SearchTextFieldUI: UITextField, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView?
    var sponsoredItem = false

    var resultsList: [String] = [] {
        didSet {
            let orderedSet = Array(NSOrderedSet(array: resultsList))
            resultsList = orderedSet as? [String] ?? []
        }
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView?.removeFromSuperview()

    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        createTableView()

    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.addTarget(self, action: #selector(SearchTextFieldUI.textFieldDidChange), for: .editingChanged)
    }

    @objc
    open func textFieldDidChange(){
        updateTableView()
        tableView?.isHidden = false
        if text?.count ?? 2 < 3 {
            tableView?.isHidden = true
        }
        if text?.count == 0 {
            resultsList.removeAll()
        }
    }

    func createTableView() {
        if let tableView = tableView {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "autoCompleteCell")
            tableView.delegate = self
            tableView.dataSource = self
            self.window?.addSubview(tableView)

        } else {
            tableView = UITableView(frame: CGRect.zero)
        }
        updateTableView()
    }

    func updateTableView() {
        if let tableView = tableView {
            superview?.bringSubviewToFront(tableView)
            var tableHeight: CGFloat = 0
            tableHeight = tableView.contentSize.height

            if tableHeight < tableView.contentSize.height {
                tableHeight -= 10
            }

            var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
            tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 2
            tableViewFrame.origin.y += frame.size.height + 2
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = tableViewFrame
            })

            tableView.layer.masksToBounds = true
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.layer.cornerRadius = 5.0
            tableView.separatorStyle = .none
            tableView.backgroundColor = UIColor.white
            tableView.layer.borderWidth = 2.0
            tableView.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 255, alpha: 1)

            if self.isFirstResponder {
                superview?.bringSubviewToFront(self)
            }
            tableView.reloadData()
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        if !resultsList.isEmpty {
            cell.textLabel?.text = resultsList[indexPath.row]
        }
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.text = resultsList[indexPath.row]
        
        tableView.isHidden = true
        resultsList.removeAll()
        self.endEditing(true)
    }
}
