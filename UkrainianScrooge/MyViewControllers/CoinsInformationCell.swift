//
//  CoinsInformationCell.swift
//  UkrainianScrooge
//

import UIKit

class CoinsInformationCell: UITableViewCell {

    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quality: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(from data : UserCoin ){
        self.note.text = data.note
        self.price.text = String(data.price)
        self.quality.text = data.quality
    }

}
