//
//  GithubUserCell.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import UIKit

class GithubUserCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI(using user: GithubUser) {
        usernameLabel.text = user.username
        urlLabel.text = user.url
        avatarImageView.setImage(from: user.avatarUrl)
    }
}
