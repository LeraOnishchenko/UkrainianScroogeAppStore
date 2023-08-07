//
//  MyCoinsViewController.swift
//  UkrainianScrooge
//
//  Created by lera on 14.03.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

class MyCoinsViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet private weak var noCoinsInCollectionLabel: UILabel!
    private let db = Firestore.firestore()
   
    @IBOutlet private weak var searchBar: UISearchBar!
    
    @IBOutlet private  weak var allCoinsTable: UITableView!
    var coins: [Coin] = []
    let Alert = MyAlert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCoins()
        setupTable()
        navigationController?.navigationBar.tintColor = .black
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        coins.removeAll()
        self.allCoinsTable.reloadData()
        searchCoins()
        setupTable()
    }
    
    func searchCoins(){
        Task {
            fetchCoins()
        }
    }
    
    private func setupTable(){
        allCoinsTable.dataSource = self
        allCoinsTable.delegate = self
    }
    
    private func fetchCoins() {
        let currId = Auth.auth().currentUser?.uid
        guard let currId = currId else {Alert.sendAlert(controller: self); return}
        db
            .collection("users").document(currId)
            .collection("BankCoin").getDocuments
        {
            snap, err in
            guard let docs = snap?.documents else {return}
            let arr = docs.map{ $0.documentID }
            if arr.isEmpty{
                self.allCoinsTable.isHidden = true
                self.noCoinsInCollectionLabel.isHidden = false
                return
            }
            self.db.collection("coins").whereField(FieldPath.documentID(), in: arr).addSnapshotListener { [weak self] documents, error in
                guard let documents = documents else {
                  print("Error fetching documents: \(error!)")
                  return
                }
                  let data = documents.documents.map({$0.data()})
                  let coins = data.compactMap({try? Coin(dict: $0)})
                  self?.coins = coins
                  self?.allCoinsTable.isHidden = false
                  self?.allCoinsTable.reloadData()
              }
        }
           
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailsCoinViewController,
            let index = allCoinsTable.indexPathForSelectedRow?.row
        {
            destination.Coin = coins[index]
        }
    }

}

extension MyCoinsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MyCoinsCell.self), for: indexPath) as! MyCoinsCell
        cell.config(from: coins[indexPath.row])
        return cell
    }
}

