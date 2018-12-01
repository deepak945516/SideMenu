//
//  ViewController.swift
//  SideMenu
//
//  Created by Deepak Kumar on 29/11/18.
//  Copyright © 2018 deepak. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var friendsPostTableView: UITableView!
    var delegate: ContainerViewDelegate?

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initialSetup()
    }

    // MARK: - Private Methods
    private func initialSetup() {
        friendsPostTableView.register(UINib.init(nibName: "FriendsPostTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsPostTableViewCell")
    }

    // MARK: - IBAction Methods
    @IBAction func sideMenuButtonTapped(_ sender: UIButton) {
        delegate?.sideMenuButtonTapped()
    }
}

// MARK: - TableView DataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postImageArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsPostTableViewCell") as? FriendsPostTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.postImageView.image = UIImage(named: postImageArray[indexPath.row])
        return cell
    }
}

// MARK: - TableView Delegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}

// optional, not concerned to side menu, it is only for homeView post button action call
// MARK: - PostButtonDelegate Like Comment ...
extension HomeViewController: PostButtonDelegate {
    func likeButtonTapped(_ sender: UIButton!) {
        let buttonPosition = sender.convert(sender.bounds.origin, to: friendsPostTableView)
        let indexPath = friendsPostTableView.indexPathForRow(at: buttonPosition)
        if let _ = friendsPostTableView.cellForRow(at: indexPath!) {

        }
    }

    func bookmarkButtonTapped(_ sender: UIButton!) {

    }

    func commentButtonTapped(_ sender: UIButton!) {

    }

    func tagFriendButtonTapped(_ sender: UIButton!) {

    }
}
