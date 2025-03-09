//
//  MessageTableViewCell.swift
//  Chatty
//
//  Created by Samir Ramic on 04.03.25.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var user1Image: UIImageView!
    @IBOutlet weak var user2Image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = containerView.frame.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
