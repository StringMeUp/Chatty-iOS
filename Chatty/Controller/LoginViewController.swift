//
//  LoginViewController.swift
//  Chatty
//
//  Created by Samir Ramic on 24.02.25.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.appName
    }
    
    @IBAction func onLoginPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text,
           let password = passwordTextField.text,
           !email.isEmpty,
           !password.isEmpty
        {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                
                if let e = error {
                    print("Error occured while logging in \(e)")
                }else{
                    self?.performSegue(withIdentifier: K.loginSegue, sender: sender)
                }
            
            }
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
