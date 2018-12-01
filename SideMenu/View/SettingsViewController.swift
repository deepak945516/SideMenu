//
//  SettingsViewController.swift
//  SideMenu
//
//  Created by Deepak Kumar on 30/11/18.
//  Copyright © 2018 deepak. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: ContainerViewDelegate?

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - IBAction Methods
    @IBAction func sideMenuButtonTapped(_ sender: UIButton) {
        delegate?.sideMenuButtonTapped()
    }
}
