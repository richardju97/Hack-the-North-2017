//
//  MessageTableViewCell.swift
//  HackTheNorth
//
//  Created by Ryuji Mano on 9/16/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import Material

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    var isUser: Bool = true
    var isError: Bool = false
    func setUp(text: String, isUser: Bool, isError: Bool) {
        self.selectionStyle = .none
        messageLabel.text = text
        if isUser {
            leftConstraint.constant = self.frame.width / 4.0
        } else {
            rightConstraint.constant = self.frame.width / 4.0
            self.isError = isError
            if isError {
                backView.backgroundColor = UIColor.red.withAlphaComponent(0.6)
            } else {
                backView.backgroundColor = UIColor.green.withAlphaComponent(0.6)
            }
        }
        self.isUser = isUser
    }
}
