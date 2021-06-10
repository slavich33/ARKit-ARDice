//
//  ViewController.swift
//  ARDicee
//
//  Created by Slava on 16.05.2021.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var diceArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
//        detectind feature points
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
//        let sphere = SCNSphere(radius: 0.2)
//
//        let material = SCNMaterial()
//
//        material.diffuse.contents = UIImage(named: "art.scnassets/8k_earth_nightmap.jpg")
//
//        sphere.materials = [material]
//
//        let node = SCNNode()
//
//        node.position = SCNVector3(0, 0.1, -0.5)
//
//        node.geometry = sphere
//
//        sceneView.scene.rootNode.addChildNode(node)
        
        sceneView.autoenablesDefaultLighting = true
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
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK: - DiceRendering

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            
            
            let results = sceneView.raycastQuery(from: touchLocation, allowing: ARRaycastQuery.Target.estimatedPlane, alignment: .any)

            
            if let hitResult = results {
                
                let rayCast = sceneView.session.raycast(hitResult)
                    
                guard let ray = rayCast.first else {
                    return

                }
                addDice(atLocation: ray)
            }
        }
    }
    
    func addDice(atLocation hitResult: ARRaycastResult) {
        
        //                 Create a new scene
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!

        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {

        diceNode.position = SCNVector3(
          hitResult.worldTransform.columns.3.x,
          hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
          hitResult.worldTransform.columns.3.z
        )

          diceArray.append(diceNode)
          
        sceneView.scene.rootNode.addChildNode(diceNode)
           
          
          
      }
    }
    
    func rollAll() {
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    func roll(dice: SCNNode) {
        
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randomX) * 5, y: 0, z: CGFloat(randomZ) * 5, duration: 0.7))
    }
    
    @IBAction func rollAgain(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    @IBAction func removeAllDice(_ sender: UIBarButtonItem) {
        
        if !diceArray.isEmpty{
            for dice in diceArray {
                dice.removeFromParentNode()
            }
        }
    }
    
    //MARK: - ARSceneViewDelegateMethods
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
     
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
           
        let planeNode = createPlane(with: planeAnchor)
        
        node.addChildNode(planeNode)
            
      
    }
    //MARK: - Plane Rendering Methods
    
    func createPlane(with planeAnchor: ARPlaneAnchor) -> SCNNode {
       
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        let planeNode = SCNNode()
        
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.y)
        
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        
        let gridMaterial = SCNMaterial()
        
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        
        plane.materials = [gridMaterial]
        
        planeNode.geometry = plane
        
        return planeNode
    }
}
