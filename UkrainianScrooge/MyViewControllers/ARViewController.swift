import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    var coinImRev: UIImage?
    var coinImAv: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        let tapGesure = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGesure)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    func addCoinModelTo(position: SCNVector3) {
        guard let coinScene = SCNScene(named: "art.scnassets/CoinsAR/model.dae") else {
            fatalError("Unable to find coin.dae")
        }
        guard let baseNode = coinScene.rootNode.childNode(withName: "baseNode", recursively: true) else {
            fatalError("Unable to find baseNode")
        }
        guard var materials = baseNode.childNodes[0].geometry?.materials else {return}
        let textureImage1 = coinImAv
        let textureImage2 = coinImRev
        let textureImage3 = UIImage(named: "art.scnassets/CoinsAR/side.jpg")!
        let material1 = SCNMaterial()
        material1.diffuse.contents = textureImage1
        let material2 = SCNMaterial()
        material2.diffuse.contents = textureImage2
        let material3 = SCNMaterial()
        material3.diffuse.contents = textureImage3
        materials[0] = material1
        materials[1] = material2
        materials[2] = material3
        baseNode.childNodes[0].geometry?.materials = materials
        baseNode.position = position
        baseNode.scale = SCNVector3Make(0.05, 0.05, 0.05)
        sceneView.scene.rootNode.addChildNode(baseNode)
        
    }
    
    // MARK: - Gesture Recognizers
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        guard let query = sceneView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .horizontal) else {return}
        guard let result = sceneView.session.raycast(query).first else {
            return
        }
        let position = SCNVector3Make(result.worldTransform.columns.3.x,
                                      result.worldTransform.columns.3.y,
                                      result.worldTransform.columns.3.z)
        addCoinModelTo(position: position)
    }
}
