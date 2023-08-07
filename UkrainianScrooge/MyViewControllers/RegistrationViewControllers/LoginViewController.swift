//
//  LoginViewController.swift
//  UkrainianScrooge
//
//  Created by lera on 11.03.2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet private weak var emailText: UITextField!
    
    @IBOutlet private weak var passwordText: UITextField!
    
    @IBOutlet private weak var loginButton: UIButton!
    
    @IBOutlet private weak var errorMessege: UILabel!
    
    @IBAction func loginTapped(_ sender: Any) {
        // TODO: Validate Text Fields
        
        let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                self.errorMessege.text = error!.localizedDescription
                self.errorMessege.alpha = 1
            }
            else {
                self.sigueToFirstScreen()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    func sigueToFirstScreen(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setUpElements() {
        
        errorMessege.alpha = 0
        
        Utilities.styleTextField(emailText)
        Utilities.styleTextField(passwordText)
        Utilities.styleFilledButton(loginButton)
        
    }

}
