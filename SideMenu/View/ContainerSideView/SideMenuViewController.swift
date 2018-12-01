//
//  SideMenuTableViewController.swift
//  SideMenu
//
//  Created by Deepak Kumar on 25/09/18.
//  Copyright © 2018 deepak. All rights reserved.
//

import UIKit

protocol SideMenuDelegate: class {
    func menuItemSelected(at indexPath: IndexPath)
}

class SideMenuViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    static var delegate: SideMenuDelegate?
    var router = Router()

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    // MARK: - Private Methods
    private func initialSetup() {
        // Default cell registration
        sideMenuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        sideMenuTableView.tableHeaderView = tableHeaderView
        // It hides the table view separator line of empty cell
        sideMenuTableView.tableFooterView = UIView(frame: CGRect.zero)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.layer.masksToBounds = true
    }
}

// MARK: - TableView DataSource
extension SideMenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? sideMenuItemArray.count: 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.textAlignment = .center
            cell?.textLabel?.textColor = UIColor.darkGray
            cell?.textLabel?.text = "Logout"
            return cell!
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            let sideMenuItemImage = UIImage(named: sideMenuItemImageArray[indexPath.row])
            cell.imageView?.frame.size = CGSize(width: 30, height: 30)
            self.view.layer.layoutIfNeeded()
            cell.imageView?.image = sideMenuItemImage
            cell.textLabel?.text = sideMenuItemArray[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 50: 100
    }
}

// MARK: - Table view delegate
extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SideMenuViewController.delegate?.menuItemSelected(at: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView(frame: CGRect.zero)
        sectionHeaderView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        let topUnderlineView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth - sideMenuTrailingConstant, height: 0.5))
        let bottomUnderlineView = UIView(frame: CGRect(x: 0, y: 24.5, width: screenWidth - sideMenuTrailingConstant, height: 0.5))
        topUnderlineView.backgroundColor = UIColor.lightGray
        bottomUnderlineView.backgroundColor = UIColor.lightGray
        sectionHeaderView.addSubview(topUnderlineView)
        sectionHeaderView.addSubview(bottomUnderlineView)
        return sectionHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
}
