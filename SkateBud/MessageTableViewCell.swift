//
//  MessageTableViewCell.swift
//  SkateBud
//
//  Created by Victor on 2022-11-03.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var textMessageLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var photoMessage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var bubbleWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
