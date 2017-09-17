//
//  TrackListTableViewCell.swift
//  HackTheNorth
//
//  Created by Ryuji Mano on 9/16/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import Kingfisher

class TrackListTableViewCell: UITableViewCell {
    @IBOutlet weak var trackView: UIImageView!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!

    func setUp(trackImage: String?, track: String, artist: String) {
        self.trackLabel.text = track
        self.artistLabel.text = artist
        if let urlString = trackImage {
            trackView.kf.setImage(with: URL(string: urlString))
        } else {
            trackView.backgroundColor = .lightGray
        }
    }
    
}
