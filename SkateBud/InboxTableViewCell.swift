//
//  InboxTableViewCell.swift
//  SkateBud
//
//  Created by Victor on 2022-11-14.
//

import UIKit

class InboxTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var user: User!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatar.layer.cornerRadius = 30
        avatar.clipsToBounds = true
    }
    
    func configureCell(uid: String, inbox: Inbox) {
        self.user = inbox.user
        avatar.loadImage(inbox.user.profileImageUrl)
        usernameLabel.text = inbox.user.username
        let date = Date(timeIntervalSince1970: inbox.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        dateLabel.text = dateString
        
        if !inbox.text.isEmpty {
            messageLabel.text = inbox.text
        } else {
            messageLabel.text = "[MEDIA]"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
