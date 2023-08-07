import AVFoundation
import UIKit

protocol CameraDelegate: AnyObject {
    func camera(_ camera: Camera, didCapture imageData: Data)
}

final class Camera: NSObject {
    
    enum CameraError: Error {
        
        case deviceUnavailable
        case cantAddInput
        case cantAddOutput
        case cantCreateLayerNow
        
    }
    
    private var captureSession: AVCaptureSession!
    
    private var currentCamera: AVCaptureDevice!
    private var currentCameraInput: AVCaptureDeviceInput!
    
    
    private var photoOutput: AVCapturePhotoOutput!
    private var videoOutput: AVCaptureMovieFileOutput!
    
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private var cameraPosition: AVCaptureDevice.Position = .back
    
    private(set) var isReady = false
    
    weak var delegate: CameraDelegate?
    
}

//MARK: Public API
extension Camera {
    
    func add(to view: UIView) throws {
        guard isReady else { throw CameraError.cantCreateLayerNow }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        
        view.layer.insertSublayer(previewLayer, at: 0)
    }
    
    func prepare() throws {
        try setupCaptureSession()
    }
    
    func switchCamera() throws {
        cameraPosition = cameraPosition == .back ? .front : .back
        
        captureSession.removeInput(currentCameraInput)
        
        try setupDevices()
        try setupInputs()
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
        
    }
    func zoom(scale: CGFloat) {
        do{
            try? currentCamera.lockForConfiguration()
            currentCamera.videoZoomFactor = scale
            currentCamera.unlockForConfiguration()
        }
        
    }
    
}

//MARK: Private API
private extension Camera {
    
    func setupCaptureSession() throws {
        guard !isReady else { return }
        
        captureSession = AVCaptureSession()
        
        try setupDevices()
        try setupInputs()
        try setupOutput()
        
        DispatchQueue(label: "camera.queue").async {
            self.captureSession.startRunning()
        }
        
        isReady = true
    }
    
    func setupDevices() throws {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: cameraPosition == .back ? [.builtInDualCamera] : [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        
        let cameras = discoverySession.devices
        
        guard let camera = cameras.first(where: { $0.position == cameraPosition }) else { throw CameraError.deviceUnavailable }
        
        currentCamera = camera
        
        try camera.lockForConfiguration()
        if camera.isFocusModeSupported(.continuousAutoFocus) {
            camera.focusMode = .continuousAutoFocus
        }
        camera.unlockForConfiguration()
    }
    
    func setupInputs() throws {
        currentCameraInput = try AVCaptureDeviceInput(device: currentCamera)
        
        if captureSession.canAddInput(currentCameraInput) {
            captureSession.addInput(currentCameraInput)
        } else {
            throw CameraError.cantAddInput
        }
    }
    
    func setupOutput() throws {
        photoOutput = AVCapturePhotoOutput()
        videoOutput = AVCaptureMovieFileOutput()
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            throw CameraError.cantAddOutput
        }
    }
    
   
    
}

extension Camera: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),

        let image = UIImage(data: data) else { return }

        delegate?.camera(self, didCapture: data)

        guard let jpegData = image.jpegData(compressionQuality: 1) ?? image.pngData(),

        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
                  .appendingPathComponent("\(Date()).png") else {
                  return
              }
              try? jpegData.write(to: url)
    }
}











