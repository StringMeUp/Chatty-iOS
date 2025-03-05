//
//  SuccessViewController.swift
//  Chatty
//
//  Created by Samir Ramic on 25.02.25.
//

import UIKit
import FirebaseAuth

class ChatViewController: UIViewController {
    
    var messages: [Message] = [
        Message(sender: "1@mail.com", body: "Hey. I was thinking about what we could do to entairtain the kids? Any help here would be fine. Any help here would be fine.\nAny help here would be fine. Any help here would be fine. Any help here would be fine. Any help here would be fine. Any help here would be fine. Any help here would be fine. Any help here would be fine. Any help here would be fine. Any help here would be fine. Any help here would be fine. Any help here would be fine. Any help here would be fine. Any help here would be fine. Any help here would be fine."),
        Message(sender: "2@mail.com", body: "Ho"),
        Message(sender: "1@mail.com", body: "Nice to see you.")
    ]

    @IBOutlet weak var uiTebleView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleKeyboard()
    }
    
    @IBAction func onLogOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ChatViewController: UITextFieldDelegate {
    func setupUI(){
        title = K.appName
        self.navigationItem.setHidesBackButton(true, animated: true)
        uiTebleView.dataSource = self
        uiTebleView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
}

private extension ChatViewController {
    func handleKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
      
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            adjustViewForKeyboard(show: true, keyboardHeight: keyboardHeight)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        adjustViewForKeyboard(show: false, keyboardHeight: 0)
    }
    
    
    func adjustViewForKeyboard(show: Bool, keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = show ? -keyboardHeight : 0
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageTableViewCell
        
        cell.labelText?.text = messages[indexPath.row].body
        return cell
    }
}
