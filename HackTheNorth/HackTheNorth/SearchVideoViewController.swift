//
//  SearchVideoViewController.swift
//  HackTheNorth
//
//  Created by Ryuji Mano on 9/16/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import FontAwesomeKit
import RxSwift
import RxCocoa
import SCLAlertView

class SearchVideoViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(cellType: TrackListTableViewCell.self)
        }
    }

    var searchTextFieldView: UIView?
    var viewModel: SearchVideoViewModel = SearchVideoViewModel()

    fileprivate var transition = SearchPopTransition()
    var disposeBag = DisposeBag()

    var tracks: [Track] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSearchTextField()
        setUpBackButton()
        getSong()
    }

    func setUpSearchTextField() {
        searchTextField.frame.size.height = 50.0
        searchTextField.becomeFirstResponder()
        searchTextField.returnKeyType = .go
        searchTextField.delegate = self
    }

    func setUpBackButton() {
        let title = FAKFontAwesome.angleLeftIcon(withSize: 30.0).image(with: CGSize(width: 26.0, height: 32.0))
        backButton.setImage(title, for: .normal)
    }

    @IBAction func didTapBackButton(_ sender: Any) {
        resignFirstResponder()
        self.navigationController?.delegate = self
        self.navigationController?.popViewController(animated: true)
    }

    func getSong() {
        searchTextField.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                if !text.isEmpty {
                    self.viewModel.getSong(query: text, success: { [unowned self] tracks in
                            self.tracks = tracks
                            self.tableView.reloadData()
                        }, failure: nil)
                }
            })
            .addDisposableTo(disposeBag)
    }

    func getLyrics(artist: String, song: String) {
        do {
            let lyrics = try testGetLyric.getLyrics(artist: artist, song: song, desiredLines: 5)
            testPostRequest.sendText(text: lyrics, success: { response in
                if let response = response["missing"] as? [String] {
                    var messageStr = "The lyrics were not able to be dubbed. The following word(s) could not be dubbed:\n"
                    for i in 0..<response.count {
                        if i == response.count - 1 {
                            messageStr += (response[i] + ".")
                        } else {
                            messageStr += (response[i] + ", ")
                        }
                    }
                    SCLAlertView().showError("Dubbing Error", subTitle: messageStr)
                } else if let response = response["url"] as? String {
                    self.performSegue(withIdentifier: "ToVideo", sender: response)
                } else {
                    SCLAlertView().showError("Network Error", subTitle: "There was an error with processing your request.")
                }
                }, failure: { error in
                SCLAlertView().showError("Network Error", subTitle: "There was an error with processing your request.")
            })
        } catch let error {
            SCLAlertView().showError("Could Not Find Lyrics", subTitle: "Could not find lyrics to the song selected.")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? VideoViewController {
            if let sender = sender as? String {
                destination.videoURL = sender
            }
        }
    }
}

extension SearchVideoViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.searchTextFieldView = self.searchTextFieldView
        return transition
    }
}

extension SearchVideoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension SearchVideoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        getLyrics(artist: tracks[indexPath.row].artist, song: tracks[indexPath.row].name)
    }
}

extension SearchVideoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: TrackListTableViewCell.self, for: indexPath)
        let track = tracks[indexPath.row]
        cell.setUp(trackImage: track.trackImage, track: track.name, artist: track.artist)
        return cell
    }
}
