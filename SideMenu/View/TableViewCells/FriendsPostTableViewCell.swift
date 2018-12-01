//
//  FriendsPostTableViewCell.swift
//  SideMenu
//
//  Created by Deepak Kumar on 29/11/18.
//  Copyright © 2018 deepak. All rights reserved.
//

import UIKit

protocol PostButtonDelegate: class {
    func likeButtonTapped(_ sender: UIButton!)
    func bookmarkButtonTapped(_ sender: UIButton!)
    func commentButtonTapped(_ sender: UIButton!)
    func tagFriendButtonTapped(_ sender: UIButton!)
}

class FriendsPostTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var postImageView: UIImageView!
    weak var delegate: PostButtonDelegate?

    // MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    // MARK: - Private Methods
    private func initialSetup() {

    }

    // MARK: - IBAction Methods
    @IBAction func postLikeButtonTapped(_ sender: UIButton!) {
        sender.isSelected = !sender.isSelected
        delegate?.likeButtonTapped(sender)
    }

    @IBAction func bookmarkButtonTapped(_ sender: UIButton!) {
        sender.isSelected = !sender.isSelected
        delegate?.bookmarkButtonTapped(sender)
    }

    @IBAction func postCommentButtonTapped(_ sender: UIButton!) {
        sender.isSelected = !sender.isSelected
        delegate?.commentButtonTapped(sender)
    }

    @IBAction func tagButtonTapped(_ sender: UIButton!) {
        sender.isSelected = !sender.isSelected
        delegate?.tagFriendButtonTapped(sender)
    }
}
