//
//  SearchViewController.swift
//  HackTheNorth
//
//  Created by Ryuji Mano on 9/16/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FontAwesomeKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTextFieldView: UIView! {
        didSet {
            let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.didTapSearchTextFieldView))
            searchTextFieldView.addGestureRecognizer(gestureRecognizer)
        }
    }
    @IBOutlet weak var messageButton: UIButton!

    fileprivate var transition = SearchTransition()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSearchTextFieldView()
        setUpButton()
    }

    func setUpSearchTextFieldView() {
        searchTextFieldView.backgroundColor = .white
        
        searchTextFieldView.layer.shadowRadius = 2.0
        searchTextFieldView.layer.shadowColor = UIColor.black.cgColor
        searchTextFieldView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        searchTextFieldView.layer.shadowOpacity = 0.2
        searchTextFieldView.layer.masksToBounds = false
    }

    func setUpButton() {
        messageButton.setImage((FAKFontAwesome.commentIcon(withSize: 50).image(with: CGSize(width: 50.0, height: 50.0))), for: .normal)
    }

    func didTapSearchTextFieldView() {
        guard let destination = storyboard?.instantiateViewController(withIdentifier: SearchVideoViewController.className) as? SearchVideoViewController else {
            return
        }
        destination.searchTextFieldView = self.searchTextFieldView
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(destination, animated: true)
    }
}

extension SearchViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originalFrame = self.searchTextFieldView.frame
        transition.searchTextFieldView = self.searchTextFieldView
        return transition
    }
}
