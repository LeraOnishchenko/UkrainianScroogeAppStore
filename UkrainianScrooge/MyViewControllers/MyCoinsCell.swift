//
//  MyCoinsCell.swift
//  UkrainianScrooge
//
//  Created by lera on 03.05.2023.
//

import UIKit

class MyCoinsCell: UITableViewCell{
    
    @IBOutlet private weak var coinName: UILabel!
    @IBOutlet private weak var coinImage: UIImageView!
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
                self.coinImage.image = UIImage(systemName: "photo.artframe")
            }
        }
    }
    
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

