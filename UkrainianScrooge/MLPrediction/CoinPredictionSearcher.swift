//
//  CoinPredictionSearcher.swift
//  UkrainianScrooge
//
//  Created by lera

import Foundation
import FirebaseFirestore
import FirebaseCore
protocol MapVM {
    var delegate: MapVMDelegate? { get set }
    
}
final class CoinPredictionSearcher: MapVM {
    var delegate: MapVMDelegate?
    
    private let db = Firestore.firestore()

    func findCoinWith(uuid: [String]){
        db.collection("coins").whereField("coinMLUuid", in: uuid)
            .getDocuments{
            snap, err in
            guard let docs = snap?.documents else {return}
            let coins = docs
                .compactMap({try? Coin(dict: $0.data())})
                self.delegate?.didFetchCoinML(coinsML: coins)
        }
        
    }
}

protocol MapVMDelegate: AnyObject {
    func didFetchCoinML(coinsML: [Coin])
}
