//
//  MessageViewController.swift
//  HackTheNorth
//
//  Created by Ryuji Mano on 9/16/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FontAwesomeKit
import SCLAlertView

struct Message {
    var text: String
    var isUser: Bool
    var isError: Bool
    var url: String?
}

class MessageViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: MessageTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var navigationBarView: UIView!

    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageViewHeightConstraint: NSLayoutConstraint!

    var disposeBag = DisposeBag()

    var arr: [Message] = []

    var rect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillShowNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillRetractNotification), name: .UIKeyboardWillHide, object: nil)

        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: "messages") as? Data {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Message] {
                self.arr = array
            }
        }

        self.automaticallyAdjustsScrollViewInsets = false
        setUpTextView()
        setUpButtons()
        reloadTableView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        let defaults = UserDefaults.standard
        let data = NSKeyedArchiver.archivedData(withRootObject: arr)
        defaults.set(data, forKey: "messages")
        defaults.synchronize()
    }

    func setUpTextView() {
        messageTextView.becomeFirstResponder()
        messageTextView.textContainerInset = .zero
        messageTextView.sizeToFit()
        messageTextView.layoutIfNeeded()
        messageTextView.delegate = self
    }

    func setUpButtons() {
        backButton.rx.image(for: .normal).onNext(FAKFontAwesome.angleLeftIcon(withSize: 30.0).image(with: CGSize(width: 26.0, height: 26.0)))
        backButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }).addDisposableTo(disposeBag)

        sendButton.rx.image(for: .normal).onNext(FAKFontAwesome.paperPlaneIcon(withSize: 30.0).image(with: CGSize(width: 30.0, height: 30.0)))
        sendButton.addTarget(self, action: #selector(MessageViewController.sendButtonTapped), for: .touchUpInside)
    }

    func sendButtonTapped() {
        if self.messageTextView.text == "" {
            return
        }

        self.arr.append(Message(text: self.messageTextView.text, isUser: true, isError: false, url: nil))
        self.reloadTableView()

        testPostRequest.sendText(text: self.messageTextView.text, success: { response in
            if let response = response["missing"] as? [String] {
                var messageStr = "Your message was not able to be dubbed. The following word(s) could not be dubbed:\n"
                for i in 0..<response.count {
                    if i == response.count - 1 {
                        messageStr += (response[i] + ".")
                    } else {
                        messageStr += (response[i] + ", ")
                    }
                }
                self.arr.append(Message(text: messageStr, isUser: false, isError: true, url: nil))
            } else if let response = response["url"] as? String {
                self.arr.append(Message(text: "Successfully dubbed!", isUser: false, isError: false, url: response))
            } else {
                self.arr.append(Message(text: "There was an error with processing your request.", isUser: false, isError: true, url: nil))
            }
            self.tableView.reloadData()
        }, failure: { error in
            self.arr.append(Message(text: "There was an error with processing your request.", isUser: false, isError: true, url: nil))
            self.tableView.reloadData()
        })

        self.messageTextView.text = ""
        self.messageTextView.frame.size.height = 34.0
        self.messageViewBottomConstraint.constant = self.rect.height
        self.tableViewHeightConstraint.constant = self.view.frame.height - (self.navigationBarView.frame.height + self.messageView.frame.height + self.rect.height)
        self.messageViewHeightConstraint.constant = 50.0
    }

    func keyboardWillShowNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboard = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                rect = keyboard.cgRectValue
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageViewBottomConstraint.constant = self.rect.height
                    self.tableViewHeightConstraint.constant = self.view.frame.height - (self.navigationBarView.frame.height + self.messageView.frame.height + self.rect.height)
                }, completion: { _ in
                    self.reloadTableView()
                })
            }
        }
    }

    func keyboardWillRetractNotification(notification: Notification) {
        UIView.animate(withDuration: 0.3, animations: {
            self.messageViewBottomConstraint.constant = 0.0
            self.tableViewHeightConstraint.constant = self.view.frame.height - (self.navigationBarView.frame.height + self.messageView.frame.height)
        }, completion: { _ in
            self.reloadTableView()
        })
    }

    func updateTableViewContentInset() {
        if tableView.numberOfRows(inSection: 0) < 1 {
            return
        }
        tableView.scrollToRow(at: IndexPath(row: tableView.numberOfRows(inSection: 0) - 1, section: 0), at: .bottom, animated: false)
    }

    func reloadTableView() {
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.updateTableViewContentInset()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? VideoViewController {
            if let sender = sender as? Message {
                destination.videoURL = sender.url
            }
        }
    }
}

extension MessageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension MessageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MessageTableViewCell.self, for: indexPath)
        let e = arr[indexPath.row]
        cell.setUp(text: e.text, isUser: e.isUser, isError: e.isError)
        return cell
    }
}

extension MessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell {
            if !cell.isUser && !cell.isError {
                performSegue(withIdentifier: "ToVideo", sender: arr[indexPath.row])
            }
        }
    }
}

extension MessageViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let prev = textView.frame
        var prevConstraint = tableViewHeightConstraint.constant
        textView.sizeToFit()
        prevConstraint -= (textView.bounds.height - prev.height)
        if prevConstraint < 200 {
            textView.frame = prev
            return
        }
        if textView.bounds.height < 34 {
            textView.frame.size.height = prev.height
        }
        tableViewHeightConstraint.constant -= (textView.bounds.height - prev.height)
        messageViewHeightConstraint.constant += (textView.bounds.height - prev.height)
        textView.frame.size.width = prev.width
        textView.layoutIfNeeded()
        if tableView.numberOfRows(inSection: 0) < 1 {
            return
        }
        tableView.scrollToRow(at: IndexPath(row: tableView.numberOfRows(inSection: 0) - 1, section: 0), at: .bottom, animated: false)
    }
}
