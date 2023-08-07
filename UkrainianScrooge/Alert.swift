//
//  Alert.swift
//  UkrainianScrooge
//

import Foundation
import UIKit

class MyAlert{
    func sendAlert(controller: UIViewController){
        let alert = UIAlertController(title: "Помилка", message: "Будь ласка зареєструйтесь або увійдіть у профіль перш ніж виконувати цю дію", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        controller.present(alert, animated: true, completion: nil)
    }
}
