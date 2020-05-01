//
//  UsersTableViewCell.swift
//  GitHub
//
//  Created by Admin on 4/10/20.
//  Copyright © 2020 Vartan Shahjahanian. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var NumberOfRepositories: UILabel!
    @IBOutlet weak var UserAvatarImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
