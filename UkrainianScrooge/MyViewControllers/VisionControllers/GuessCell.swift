//
//  GuessCell.swift
//  UkrainianScrooge
//
//  Created by lera on 23.03.2023.
//

import UIKit

class GuessCell: UITableViewCell {

    @IBOutlet private weak var coinImage: UIImageView!
    
    @IBOutlet private weak var coinName: UILabel!
    
    let apiSession = ApiSesson()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func config(from data : Coin ){
        self.coinName.text = data.name
        Task {
            guard let url = URL(string: data.imgRev!) else {
                return
            }
            let imageData = try? await apiSession.retrieveImageData(url: url)
            if let imageData = imageData {
                if let loadedImage = UIImage(data: imageData) {
                    self.coinImage.image = loadedImage
                }
            } else {
                print("Error!")
            }
        }
    }

}
