//
//  coinsInCollectionController.swift
//  UkrainianScrooge
//

import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

class CoinsInCollectionController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let db = Firestore.firestore()
    
    @IBOutlet private weak var sumOfCoins: UILabel!
    
    var coinUUID: String = ""
    var userCoins: [UserCoin] = []
    let Alert = MyAlert()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCoins()
        setupTable()
    }
    
    private func setupTable(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    private func searchCoins() {
        Task{
            let currId = Auth.auth().currentUser?.uid
            guard let currId = currId else {Alert.sendAlert(controller: self); return}
            db.collection("users").document(currId)
                .collection("BankCoin")
                .document(coinUUID)
                .collection("userCoin")
                .getDocuments{ [weak self] documents, error in
                    guard let documents = documents?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                    }
                    let coins = documents.compactMap({try? UserCoin(dict: $0.data(),id: $0.documentID)})
                    self?.userCoins = coins
                    self?.sumOfCoins.text = ("Усього монет: \(coins.count)")

                    self!.tableView.reloadData()
                }
        }
    }

}

extension CoinsInCollectionController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.userCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CoinsInformationCell.self), for: indexPath) as! CoinsInformationCell
            cell.config(from: userCoins[indexPath.row])
        
        return cell
    }
}
