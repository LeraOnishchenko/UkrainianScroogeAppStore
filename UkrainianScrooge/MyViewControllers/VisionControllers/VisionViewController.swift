//
//  VisionViewController.swift
//  UkrainianScrooge
//
//  Created by lera on 14.03.2023.
//

import UIKit
import Photos
import PhotosUI

class VisionViewController: UIViewController {
    
    @IBOutlet private weak var slider: UISlider!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageData = sender as? Data {
            (segue.destination as? CoinGuessViewController)?.imageData = imageData
            
        }
    }
    
    @IBAction func Camerazoom(_ sender: UISlider) {
        camera.zoom(scale: CGFloat(sender.value))
    }
    
    func showPhotoLibrary(){
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func ifDeniedLib(){
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Дозовольте доступ до своїх фотографій",
                                              message: "Перейдіть до налаштувань та натисніть \"Фото\".",
                                              preferredStyle: .alert)
                let notNowAction = UIAlertAction(title: "Не зараз",
                                                 style: .cancel,
                                                 handler: nil)
                alert.addAction(notNowAction)
                let openSettingsAction = UIAlertAction(title: "Відкрити налаштування",
                                                       style: .default) { [unowned self] (_) in
                    // Open app privacy settings
                    gotoAppPrivacySettings()
                }
                alert.addAction(openSettingsAction)
                self.present(alert, animated: true, completion: nil)
            }
    }
    
    func askPermission(){
        let currStatus = PHPhotoLibrary.authorizationStatus(for: PHAccessLevel.readWrite)
        PHPhotoLibrary.requestAuthorization(for: PHAccessLevel.readWrite,handler: {(status) in
            if status == PHAuthorizationStatus.limited
            {
                PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
            }
            else if status == PHAuthorizationStatus.authorized {
                
                DispatchQueue.main.async {
                    self.showPhotoLibrary()
                }
            }
                    else{
                        if status == PHAuthorizationStatus.denied {
                            self.ifDeniedLib()
                        }
                    }
            
        })
    }
    
    
    @IBOutlet private weak var cameraView: UIView!
    
    @IBAction func downloadRromGallery(_ sender: Any) {
        askPermission()
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        camera.capturePhoto()
    }
    
    private let camera = Camera()
    private let minScale: CGFloat     = 1
    private let maxScale: CGFloat     = 4
    private let initialScale: CGFloat = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try? camera.prepare()
        try? camera.add(to: cameraView)
        
        camera.delegate = self

        slider.minimumValue = Float(minScale)
        slider.maximumValue = Float(maxScale)
        slider.value = Float(initialScale)
        
    }
    
    func gotoAppPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else {
                assertionFailure("Not able to open App privacy settings")
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

}

extension VisionViewController:  PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self){ [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    if let image = image as? UIImage{
                        picker.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "photo", sender: image.pngData())
                    }
                }
                
            }
        }
    }
}

extension VisionViewController: CameraDelegate {
    func camera(_ camera: Camera, didCapture imageData: Data) {
        performSegue(withIdentifier: "photo", sender: imageData)
    }
}
