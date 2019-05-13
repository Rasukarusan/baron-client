//
//  ViewController.swift
//  BaronClient
//
//  Created by tanaka.naoto on 2019/03/15.
//  Copyright © 2019年 tanaka.naoto. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import CoreLocation
import Lottie

class ViewController: UIViewController {
    let NODE_NAME_BARON : String = "baron"
    var arSceneView = ARSCNView()
    var locationManager: CLLocationManager!
    var loadAnimeView = LOTAnimationView()
    var meowAnimeView = LOTAnimationView()
    var lat : Double = 0.0
    var lon : Double = 0.0
    let arrowLbl = UILabel()
    let lbl1 = UILabel()
    let lbl2 = UILabel()
    let inputX = UITextField()
    let inputY = UITextField()
    
    var initialAnchor : ARPlaneAnchor!
    var add = 0.5
    
    private var isFloorRecognized = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildUI()
        self.registTapGesture()   
    }
    
    private func addCat(initAnchor: ARPlaneAnchor) {
        APIClient.getCat { cat in
            let axis:[Float] = self.convertCatAxisToAR(x: cat.locale.next_x_grid, y: cat.locale.next_y_grid)
            let point:SCNVector3 = SCNVector3Make(
                initAnchor.transform.columns.3.x + axis[0],
                initAnchor.transform.columns.3.y,
                initAnchor.transform.columns.3.z - axis[1]
            )
            self.arSceneView.scene.rootNode.addChildNode(self.makeNode(point: point))
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        self.arSceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.arSceneView.session.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }        
}

extension ViewController : ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self.rotateArrowToCat()
        if(self.initialAnchor == nil) {
            return
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        self.meow()
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        if !isFloorRecognized {
            self.initialAnchor = planeAnchor
            arSceneView.debugOptions = []
            isFloorRecognized = true
            self.addCat(initAnchor: planeAnchor)
            self.hideLoading()
        }
    }
}

