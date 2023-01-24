//
//  UserAroundCollectionViewCell.swift
//  SkateBud
//
//  Created by Victor on 2022-11-26.
//

import UIKit

class UserAroundCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var onlineView: UIImageView!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        onlineView.backgroundColor = UIColor.red
        onlineView.layer.cornerRadius = 10/2
        onlineView.clipsToBounds = true
    }
}
