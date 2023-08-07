//
//  SingInViewController.swift
//  UkrainianScrooge
//
//  Created by lera on 11.03.2023.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift

class SignUpViewController: UIViewController {
    
        @IBOutlet private weak var passwordText: UITextField!
        @IBOutlet private weak var lastNameText: UITextField!
        @IBOutlet private weak var firstNameText: UITextField!
        @IBOutlet private weak var emailText: UITextField!
        @IBOutlet private weak var errorMessege: UILabel!
        @IBOutlet private weak var signUpButton: UIButton!
    
        private let db = Firestore.firestore()
    
    @IBAction func singUpTapped(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            showError(error!)
        }
        else {
            let firstName = firstNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            Auth.auth().createUser(withEmail: email, password: password) {
                (result, err) in
                if err != nil {
                    self.showError("Помилка створення користувача")
                }
                else {
                    let uid = result?.user.uid
                    self.createUser(uuid: uid!, firstName: firstName, lastName: lastName)
                    self.transitionToHome()
                }
            }
        }
    }
    
    func createUser(uuid: String, firstName: String, lastName: String){
        try? db.collection("users").document(uuid).setData(from: User(firstname: firstName, lastname: lastName))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setUpElements()
    }

    func setUpElements() {
        errorMessege.alpha = 0
        Utilities.styleTextField(firstNameText)
        Utilities.styleTextField(lastNameText)
        Utilities.styleTextField(emailText)
        Utilities.styleTextField(passwordText)
        Utilities.styleFilledButton(signUpButton)
    }

    func validateFields() -> String? {

        if firstNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {

            return "Будь ласка заповніть всі поля."
        }

        let cleanedPassword = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Будь ласка впевніться, що пароль містить як мінімум 8 знаків, включаючи спеціальні символи та цифри."
        }

        return nil
    }
    
    func showError(_ message:String) {

        errorMessege.text = message
        errorMessege.alpha = 1
    }
    
    func transitionToHome() {
        self.navigationController?.popToRootViewController(animated: true)

    }

}
