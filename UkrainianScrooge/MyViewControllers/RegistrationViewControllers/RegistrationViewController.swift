//
//  RegistrationViewController.swift
//  UkrainianScrooge
//
//  Created by lera on 11.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegistrationViewController: UIViewController {

    let Alert = MyAlert()
    @IBOutlet private weak var singOutButton: UIButton!
    
    @IBAction func deleteButton(_ sender: Any) {
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
        guard let user = user else {Alert.sendAlert(controller: self);return}
        db.collection("users").whereField("uid", isEqualTo: user.uid).getDocuments{ users, errr in
            if let errr = errr {
                return
            }
            if let users = users {
                users.documents.forEach { userDoc in
                    db.collection("users").document(userDoc.documentID).delete() { (error) in
                        if error != nil {
                            return
                        }

                    }
                }
            }
            user.delete { error in
                if let error = error {
                    print(error)
                } else {
                    let registrationVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.registrationViewController) as? RegistrationViewController

                    self.navigationController?.viewControllers = [registrationVC!]
                }
            }
        }
    }
    
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBAction func singOutButtonTap(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        } catch let signOutError{
           print("error", signOutError)
        }
    }
    @IBOutlet private weak var signUpButton: UIButton!
    
    @IBOutlet private weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Реєстрація"
        setUpElements()
        navigationController?.navigationBar.tintColor = .black
    }

    func setUpElements() {

        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        Utilities.styleDeleteButton(deleteAccountButton)
        Utilities.styleDeleteButton(singOutButton)
    }

}
