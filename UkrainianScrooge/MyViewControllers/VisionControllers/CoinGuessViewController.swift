//
//  CoinGuessViewController.swift
//  UkrainianScrooge
//
//  Created by lera on 22.03.2023.
//

import UIKit

class CoinGuessViewController: UIViewController, UITableViewDelegate {
    var imageData : Data!
    
    @IBOutlet private weak var guessTable: UITableView!

    @IBOutlet private weak var userCoinImage: UIImageView!
    
    var coinsML: [Coin] = []
    private let coinSearcher = CoinPredictionSearcher()
    private let predictor = Predictor()

    override func viewDidLoad() {
        super.viewDidLoad()
        coinSearcher.delegate = self
        let image = self.resizeImage(image: UIImage(data: imageData)!, targetSize: CGSizeMake(256.0, 256.0))
        userCoinImage.image = UIImage(data: imageData)
        DispatchQueue.global(qos: .userInteractive).async {
            self.predictor.predict(image: image!, completion: self.showPrediction)
        }
        setupTable()
    }
    
    private func setupTable(){
        guessTable.dataSource = self
        guessTable.delegate = self
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        let rect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func showPrediction(_ predictions: [Prediction]?) {
        guard let prediction = predictions?.first else{return}
        coinSearcher.findCoinWith(uuid: predictions!.prefix(upTo: 10).compactMap{$0.0})
    }
    
    private func updateCoinML(coinsML: [Coin]) {
        self.coinsML = coinsML
        guessTable.reloadData()
    }
    
}
extension CoinGuessViewController: MapVMDelegate {
    func didFetchCoinML(coinsML: [Coin]){
        updateCoinML(coinsML: coinsML)
    }
}


extension CoinGuessViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coinsML.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GuessCell.self), for: indexPath) as! GuessCell
        cell.config(from: coinsML[indexPath.row])
        return cell
    }
}
