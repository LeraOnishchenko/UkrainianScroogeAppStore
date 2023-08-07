//
//  Predictor.swift
//  FirstML
//


import Foundation
import UIKit
import Vision

typealias Prediction = (String, Float)

class Predictor {

    private var completion: (([Prediction]?) -> Void)?

    lazy var model: VNCoreMLModel = {
        let config = MLModelConfiguration()
        let baseModel = try! modelCoinImgF(configuration: config)
        return try! VNCoreMLModel(for: baseModel.model)
    }()

    func predict(image: UIImage, completion: @escaping (([Prediction]?) -> Void)) {
        self.completion = completion

        let request = classificationRequest()
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, orientation: CGImagePropertyOrientation(image.imageOrientation))
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }

    private func classificationRequest() -> VNImageBasedRequest {
        let request = VNCoreMLRequest(model: model, completionHandler: requestCompletionHandler(_:error:))
        request.imageCropAndScaleOption = .centerCrop
        return request
    }

    private func requestCompletionHandler(_ request: VNRequest, error: Error?) {
        guard let obsrvations = request.results as? [VNClassificationObservation] else {
            return
        }
        completion?(obsrvations.sorted(by: { $0.confidence > $1.confidence }).map { obs in
            (obs.identifier, obs.confidence)
        })
    }
}
