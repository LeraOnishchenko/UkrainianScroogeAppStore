//
//  FilterCell.swift
//  UkrainianScrooge
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet private weak var filterName: UILabel!

    var item: ViewModelItem? {
        didSet {
            filterName?.text = item?.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
}
