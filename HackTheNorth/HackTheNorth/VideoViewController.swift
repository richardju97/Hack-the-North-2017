//
//  VideoViewController.swift
//  HackTheNorth
//
//  Created by Ryuji Mano on 9/17/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Material
import Player
import BMPlayer
import SCLAlertView

class VideoViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var player: BMPlayer!

    var videoURL: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBackButton()

        if let url = URL(string: videoURL) {
            let asset = BMPlayerResource(url: url)
            player.setVideo(resource: asset)
            player.play()
            player.backBlock = { [unowned self] isFullScreen in
                if isFullScreen {
                    return
                }
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }


    func setUpBackButton() {
        backButton.setImage(FAKFontAwesome.angleLeftIcon(withSize: 30).image(with: CGSize(width: 26.0, height: 26.0)), for: .normal)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }


    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension VideoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
