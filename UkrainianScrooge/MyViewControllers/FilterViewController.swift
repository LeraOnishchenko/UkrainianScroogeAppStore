//
//  FilterViewController.swift
//  UkrainianScrooge
//
//  Created by lera on 04.05.2023.
//

import UIKit
import FirebaseFirestore
import Firebase

class FilterViewController: UIViewController {
    var delegate: AddFilterDelegate?
    private let db = Firestore.firestore()
    var viewModel = ViewModel()
    var coins: [Coin] = []
    @IBAction func save(_ sender: Any) {
        
        let filter = viewModel.selectedItems.map { $0.title }.first
        switch filter {
        case "За назвою":
                self.delegate?.addFilter(filter: "За назвою")
        default:
            print("unknown filter")
            return
        }
        self.dismiss(animated: true)
        
    }
    @IBOutlet private weak var saveButton: UIButton!
    
    @IBOutlet private weak var filterTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTable?.dataSource = viewModel
        filterTable?.delegate = viewModel
        filterTable?.separatorStyle = .none
        viewModel.didToggleSelection = { [weak self] hasSelection in
        self?.saveButton?.isEnabled = hasSelection
        }
        
    }
}
protocol AddFilterDelegate {
    func addFilter(filter: String)
}
