//
//  ElseViewController.swift
//  UkrainianScrooge
//
//  Created by lera on 14.03.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

class ElseViewController: UIViewController {

    @IBOutlet private weak var countCollectionPriceButton: UIButton!
    private let db = Firestore.firestore()
    

    @IBOutlet weak var CollectionPriceText: UILabel!
    @IBAction func countCollectionPrice(_ sender: Any) {
        let currId = Auth.auth().currentUser?.uid
        var sum = 0.0
        guard let currId = currId else {return}
        db.collection("users").document(currId).collection("BankCoin").getDocuments{
            docs,err in
            guard let docs = docs?.documents else {self.CollectionPriceText.text = "0"; return}
            let gotCoins = docs.compactMap{$0.documentID}
            gotCoins.forEach{ gotCoin in
                self.db.collection("users").document(currId).collection("BankCoin").document(gotCoin).collection("userCoin").getDocuments{
                    cdocs, cerrs in
                    guard let cdocs = cdocs?.documents else {self.updateText(sum: sum); return}
                    let coinsObjs = cdocs.compactMap{try? UserCoin(dict: $0.data(), id: $0.documentID)}
                    coinsObjs.forEach{coinObj in
                        sum += coinObj.price
                        self.updateText(sum: sum)
                    }
                }
            }
        }
       
    }
    
    func updateText(sum: Double){
        self.CollectionPriceText.text = "Загальна вартість Вашої колекції\n складає : \(String(sum))грн"
        self.CollectionPriceText.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let currId = Auth.auth().currentUser?.uid
        self.countCollectionPriceButton.isHidden = false
        guard let currId = currId else {self.countCollectionPriceButton.isHidden = true; return}
        navigationController?.navigationBar.tintColor = .black

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.CollectionPriceText.isHidden = true
        let currId = Auth.auth().currentUser?.uid
        self.countCollectionPriceButton.isHidden = false
        guard let currId = currId else {self.countCollectionPriceButton.isHidden = true; return}
        
    }

}
