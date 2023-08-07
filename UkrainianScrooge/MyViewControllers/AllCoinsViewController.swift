//
//  AllCoinsViewController.swift
//  UkrainianScrooge
//
//  Created by lera on 14.03.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseCore

class AllCoinsViewController: UIViewController, UITableViewDelegate {
    
    private let db = Firestore.firestore()
    
    @IBOutlet private weak var searchBar: UISearchBar!
    
    @IBOutlet private  weak var allCoinsTable: UITableView!
    var coins: [Coin] = []
    var isSearching = false
    
    var filter: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        searchCoins()
        searchBar.delegate = self
        navigationController?.navigationBar.tintColor = .black
        
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
    
    private func applyFilter(filter: String){
        self.filter = filter
        fetchCoins()
    }
    
    private func fetchCoins() {
        guard let filter = filter else {
            db.collection("coins").limit(to: 10)
                .addSnapshotListener { [weak self] documents, error in
                  guard let documents = documents else {
                    print("Error fetching documents: \(error!)")
                    return
                  }
                    let data = documents.documents.map({$0.data()})
                    let coins = data.compactMap({try? Coin(dict: $0)})
                    self?.coins = coins
                    self!.allCoinsTable.reloadData()
                }
            return;
        }
        switch filter{
        case "За назвою":
            db.collection("coins").order(by: "name").limit(to: 10)
                .addSnapshotListener { [weak self] documents, error in
                  guard let documents = documents else {
                    print("Error fetching documents: \(error!)")
                    return
                  }
                    let data = documents.documents.map({$0.data()})
                    let coins = data.compactMap({try? Coin(dict: $0)})
                    self?.coins = coins
                    self!.allCoinsTable.reloadData()
                }
            return
        default:
            return
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailsCoinViewController,
            let index = allCoinsTable.indexPathForSelectedRow?.row
        {
            destination.Coin = coins[index]
        }
        
        if let destinat = segue.destination as? FilterViewController{
            destinat.delegate=self
        }
        
    }
    
    private func reloadPosts(afterId: String){
        guard let filter = filter else {
            db.collection("coins").document(afterId).getDocument{
                [weak self] doc, err in
                guard let self = self else {return}
                guard let doc = doc else {return}
                db.collection("coins").start(afterDocument: doc).limit(to: 10)
                    .addSnapshotListener { [weak self] documents, error in
                        guard let documents = documents else {
                            print("Error fetching documents: \(error!)")
                            return
                        }
                        let data = documents.documents.map({$0.data()})
                        let coins = data.compactMap({try? Coin(dict: $0)})
                        self?.coins += coins
                        self!.allCoinsTable.reloadData()
                    }
            }
            return
        }
        if filter.elementsEqual("За назвою"){
            db.collection("coins").document(afterId).getDocument{
                [weak self] doc, err in
                guard let self = self else {return}
                guard let doc = doc else {return}
                db.collection("coins").order(by: "name").start(afterDocument: doc).limit(to: 10)
                    .addSnapshotListener { [weak self] documents, error in
                        guard let documents = documents else {
                            print("Error fetching documents: \(error!)")
                            return
                        }
                        let data = documents.documents.map({$0.data()})
                        let coins = data.compactMap({try? Coin(dict: $0)})
                        self?.coins += coins
                        self!.allCoinsTable.reloadData()
                    }
            }
        }
        else {
            return
        }
    }

}

extension AllCoinsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                   return self.coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AllCoinsCell.self), for: indexPath) as! AllCoinsCell
                   cell.config(from: coins[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isSearching {
            return
        }
        if indexPath.row == coins.count - 2 {
            self.reloadPosts(afterId: coins.last?.uuid ?? "")
                        DispatchQueue.main.async {
                            self.allCoinsTable.reloadData()
                        }
                }
            }
}

extension AllCoinsViewController: AddFilterDelegate {

    func addFilter(filter: String) {
        self.dismiss(animated: true) {
            self.applyFilter(filter: "За назвою")
        }
    }
}

extension AllCoinsViewController: UISearchBarDelegate {
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
         searchBar.showsCancelButton = true
        if searchBar.text == "" {
            isSearching = false
            allCoinsTable.reloadData()
        } else {
                   isSearching = true
            db.collection("coins").whereField("name", isGreaterThanOrEqualTo: searchText).whereField("name", isLessThanOrEqualTo: "\(searchText)\u{f7ff}")
                .getDocuments{ [weak self] documents, error in
                  guard let documents = documents else {
                    print("Error fetching documents: \(error!)")
                    return
                  }
                    let data = documents.documents.map({$0.data()})
                    let coins = data.compactMap({try? Coin(dict: $0)})
                    self?.coins = coins
                    self!.allCoinsTable.reloadData()
                }

               }
    }
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
        {
            searchBar.resignFirstResponder()
            searchBar.showsCancelButton = false
            
        }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}
