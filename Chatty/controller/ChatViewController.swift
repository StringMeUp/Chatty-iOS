//
//  SuccessViewController.swift
//  Chatty
//
//  Created by Samir Ramic on 25.02.25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    @IBOutlet weak var uiTebleView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var hintLabel: UILabel!
    
    let db = Firestore.firestore()
    var messages: [Message] = []
    var listener: ListenerRegistration? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getMessages()
        handleKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener?.remove()
    }
    
    //MARK: - Button Actions
    
    @IBAction func onLogOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out:", signOutError)
        }
    }
    
    //MARK: - Send Message
    
    @IBAction func onSendPressed(_ sender: UIButton) {
        if let sender = Auth.auth().currentUser?.email, let body = textView.text{
            let date = Date().timeIntervalSince1970
            let message = Message(sender: sender, body: body, date: date)
            
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: message.sender,
                K.FStore.bodyField: message.body,
                K.FStore.dateField: message.date
            ]) { error in
                if let error = error {
                    print("Error adding data: \(error.localizedDescription)")
                } else {
                    print("Success adding data")
                }
            }
        }
        
        self.textView.text = ""
        self.textView.endEditing(true)
    }
    
    //MARK: - Get (All) Messages
    
    func getMessages() {
         listener = db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
                if let snapshot = querySnapshot{
                    self.messages = []
                    for document in snapshot.documents {
                        
                        let sender = document.data()[K.FStore.senderField] as! String
                        let body = document.data()[K.FStore.bodyField] as! String
                        let date = document.data()[K.FStore.dateField] as! Double
                        
                        self.messages.append(Message(sender: sender, body: body, date: date))
                        
                        DispatchQueue.main.async {
                            self.uiTebleView.reloadData()
                            self.uiTebleView.scrollToRow(at: IndexPath(row: (self.messages.count - 1), section: 0), at: .bottom, animated: false)
                        }
                    }
                }
            }
        
    }
}

private extension ChatViewController {
    func setupUI(){
        
        uiTebleView.dataSource = self
        textView.delegate = self
        textView.isScrollEnabled = false
        title = K.appName
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        uiTebleView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
    }
}


extension ChatViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        hintLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        hintLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        hintLabel?.isHidden = true
    }
    
}

//MARK: - Keyboard handling

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

//MARK: - Data Source for UITable

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageTableViewCell
        
        let message = messages[indexPath.row]
        let user = Auth.auth().currentUser
        if let user = user {
            let email = user.email
            if email == message.sender{
                cell.user1Image.isHidden = false
                cell.user2Image.isHidden = true
                cell.containerView.backgroundColor = UIColor.systemYellow
            }else{
                cell.user2Image.isHidden = false
                cell.user1Image.isHidden = true
                cell.containerView.backgroundColor = UIColor.init(named: K.BrandColors.lightPurple)
            }
        }
        
        cell.messageText?.text = messages[indexPath.row].body
        return cell
    }
}
