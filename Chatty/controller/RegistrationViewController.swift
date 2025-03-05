//
//  RegistrationViewController.swift
//  Chatty
//
//  Created by Samir Ramic on 24.02.25.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.appName
    }
    
    @IBAction func onRegisterPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text,
           let password = passwordTextField.text,
           !email.isEmpty,
           !password.isEmpty
        {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                print("Users email: \(email) and password: \(password).")
                if let e = error {
                    print("Error occured while logging in \(e)")
                }else{
                    self.performSegue(withIdentifier: K.registerSegue, sender: sender)
                }
            }
        }else{
            print("Email or password are null or empty.")
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
