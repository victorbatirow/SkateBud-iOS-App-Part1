//
//  UserTableViewCell.swift
//  SkateBud
//
//  Created by Victor on 2022-10-26.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatar.layer.cornerRadius = 30
        avatar.clipsToBounds = true
    }
    
    func loadData(_ user: User) {
        self.usernameLbl.text  =  user.username
        self.statusLbl.text = user.status
        self.avatar.loadImage(user.profileImageUrl)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
