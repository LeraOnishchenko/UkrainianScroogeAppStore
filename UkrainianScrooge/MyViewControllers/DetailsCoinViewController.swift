//
//  DetailsCoinViewController.swift
//  UkrainianScrooge
//
//  Created by lera on 18.03.2023.
//

import UIKit

class DetailsCoinViewController: UIViewController {
    let apiSession = ApiSesson()

    private var coinImRev: UIImage?
    private var coinImAv: UIImage?
    @IBOutlet private weak var coinName: UILabel!
    
    @IBOutlet private weak var coinImage: UIImageView!
    
    @IBOutlet private weak var averseLabel: UILabel!
    
    @IBOutlet private weak var reverseLable: UILabel!
    
    @IBOutlet private weak var coinDescription: UILabel!
    
    @IBOutlet private weak var startedSellingAt: UILabel!
    
    @IBOutlet private weak var nominalVal: UILabel!
    
    @IBOutlet private weak var material: UILabel!
    
    @IBOutlet private weak var weight: UILabel!
    
    @IBOutlet private weak var diameter: UILabel!
    
    @IBOutlet private weak var quantityActual: UILabel!
    
    @IBOutlet private weak var tag: UILabel!
    
    @IBOutlet private weak var sculptors: UILabel!
    
    @IBOutlet private weak var artists: UILabel!
    var Coin: Coin? = nil
    weak var delegate: AllCoinsCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SaveCoinViewController,
           let coinUUID = self.Coin?.uuid
            
        {
            destination.coinUUID = coinUUID
        }
        
        if let destination = segue.destination as? CoinsInCollectionController,
           let coinUUID = self.Coin?.uuid
            
        {
            destination.coinUUID = coinUUID
        }
        
        if let destination = segue.destination as? ARViewController
        {
            destination.coinImAv = coinImAv
            destination.coinImRev = coinImRev
        }
    }
    
    func configView(){
        guard let Coin = self.Coin else{return}
        self.coinName.text = Coin.name
        self.averseLabel.text = Coin.desc[1]
        self.reverseLable.text = Coin.desc[2]
        self.coinDescription.text = Coin.desc[0]
        self.startedSellingAt.text = Coin.startedSellingAt
        self.nominalVal.text = Coin.nominalVal
        self.material.text = Coin.material
        self.weight.text = String(Coin.weight!)
        self.diameter.text = String(Coin.diameter!)
        self.quantityActual.text = String(Coin.quantityAct)
        self.tag.text = Coin.tag
        self.sculptors.text = Coin.sculptors
        self.artists.text = Coin.artists
        Task {
            guard let url = URL(string: Coin.imgRev!) else {
                return
            }
            let imageData = try? await apiSession.retrieveImageData(url: url)
            if let imageData = imageData {
                if let loadedImage = UIImage(data: imageData) {
                    self.coinImRev = loadedImage
                    self.coinImage.image = loadedImage
                }
                
            } else {
                self.coinImage.image = UIImage(systemName: "photo.artframe")
            }
            
           

        }
        Task {
            guard let url = URL(string: Coin.imgAv!) else {
                return
            }
            let imageData = try? await apiSession.retrieveImageData(url: url)
            if let imageData = imageData {
                if let loadedImage = UIImage(data: imageData) {
                    self.coinImAv = loadedImage
                }
                
            }
        }
        
    }
    
    

}
