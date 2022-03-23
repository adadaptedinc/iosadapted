//
//  ViewController.swift
//  iosSDK
//
//  Created by mkruk2 on 01/26/2022.
//  Copyright (c) 2022 mkruk2. All rights reserved.
//

import aa_multiplatform_lib
import UIKit

class ViewController: UIViewController {

    let zoneView = IosZoneViewKt.createZoneView()

    override func viewDidLoad() {
        super.viewDidLoad()
        zoneView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidAppear(_ animated: Bool) {
        view.addSubview(zoneView)
        setupConstraints()
    }

    func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(zoneView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0))
        constraints.append(zoneView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0))
        constraints.append(zoneView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20))
        constraints.append(zoneView.heightAnchor.constraint(equalToConstant: 120.0))
        NSLayoutConstraint.activate(constraints)
    }
}
