//
//  SaveCoinViewController.swift
//  UkrainianScrooge
//
//  Created by lera on 23.04.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseAuth

class SaveCoinViewController: UIViewController {
    private let db = Firestore.firestore()
    
    var userCoin: [UserCoin] = []
    var goodQuantityInt = 0
    var normalQuantityInt = 0
    var badQuantityInt = 0
    var coinQuality = coinQualityEnum.good.rawValue
    var coinUUID: String = ""
    let minValue = 1
    let maxValue = 1000000000000
    lazy var valuesRange = minValue...maxValue
    let Alert = MyAlert()
    
    @IBOutlet private weak var QualityPicker: UIPickerView!
    @IBAction func priceTab(_ sender: Any) {
       
    }
    
    @IBAction func save(_ sender: Any) {
        let currId = Auth.auth().currentUser?.uid
        guard let currId = currId else {Alert.sendAlert(controller: self); return}
        let uuid = UUID().uuidString
        let coin = UserCoin(note: self.noteText.text ?? "", price: Double(self.priceText.text ?? "0.0") ?? 0.0, quality: coinQuality)
        db.collection("users").document(currId).collection("BankCoin").document(coinUUID).setData(["coinUuid":coinUUID])
        try? db.collection("users").document(currId).collection("BankCoin").document(coinUUID).collection("userCoin").document(uuid).setData(from: coin)
        self.navigationController?.popViewController(animated: true)
    }
    
    func update(user: User){
        let currId = Auth.auth().currentUser?.uid
        guard let currId = currId else {return}
        try? db.collection("users").document(currId).setData(from: user)
    }
    
    func editDoc(){
        
    }
    
    @IBOutlet private weak var noteText: UITextField!
    
    @IBOutlet private weak var priceText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceText.delegate = self
        QualityPicker.dataSource = self
        QualityPicker.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        priceText.resignFirstResponder()
        noteText.resignFirstResponder()
    }
}
extension SaveCoinViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
             coinQuality = coinQualityEnum.good.rawValue
        case 1:
            coinQuality = coinQualityEnum.normal.rawValue
        default:
            coinQuality = coinQualityEnum.bad.rawValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch row {
            case 0:
                return coinQualityEnum.good.rawValue
            case 1:
                return coinQualityEnum.normal.rawValue
            default:
                return coinQualityEnum.bad.rawValue
            }
    }
    
    
}

extension SaveCoinViewController: UITextFieldDelegate {
    func textField(_ priceText: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let newText = NSString(string: priceText.text!).replacingCharacters(in: range, with: string)
    if newText.isEmpty {
      return true
    }
    return valuesRange.contains(Int(newText) ?? minValue - 1)
  }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

