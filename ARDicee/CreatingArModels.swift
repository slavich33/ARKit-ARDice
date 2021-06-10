//
//  CreatingArModels.swift
//  ARDicee
//
//  Created by Slava on 19.05.2021.
//

import Foundation
import SceneKit
import ARKit

class JustAR: UIViewController, ARSCNViewDelegate {
    
//    we needed to create a scene, it will be in the storyboard
    
override func viewDidLoad() {
    super.viewDidLoad()
    
//    self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
//        detectind feature points
    
    
    // Set the view's delegate
//    sceneView.delegate = self
    
        let sphere = SCNSphere(radius: 0.2)

        let material = SCNMaterial()

        material.diffuse.contents = UIImage(named: "art.scnassets/8k_earth_nightmap.jpg")

        sphere.materials = [material]

        let node = SCNNode()

        node.position = SCNVector3(0, 0.1, -0.5)

        node.geometry = sphere

//        sceneView.scene.rootNode.addChildNode(node)
    
//    sceneView.autoenablesDefaultLighting = true
//
    // Set the scene to the view
//        sceneView.scene = scene
}

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Create a session configuration
    let configuration = ARWorldTrackingConfiguration()
    
    configuration.planeDetection = .horizontal

    // Run the view's session
//    sceneView.session.run(configuration)
}

override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Pause the view's session
//    sceneView.session.pause()
}

}
