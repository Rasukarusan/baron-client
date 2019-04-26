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
        self.setLocationManager()        
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
//        self.showAlert(message: "床検知にゃん")
        self.meow()
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        if !isFloorRecognized {
            self.initialAnchor = planeAnchor
            // 特異点抽出を中止するため空配列を定義
            arSceneView.debugOptions = []
            isFloorRecognized = true
            self.arSceneView.scene.rootNode.addChildNode(makeCat(initAnchor: planeAnchor))
//            self.showAlert(message: "猫追加したにゃん")
            self.hideLoading()
        }
    }
    
    private func makeCat(initAnchor: ARPlaneAnchor) -> SCNNode {
        let point = SCNVector3Make(initAnchor.transform.columns.3.x, initAnchor.transform.columns.3.y, initAnchor.transform.columns.3.z)
        return makeNode(point: point)
    }    
}

extension ViewController : ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        let currentCamera = session.currentFrame?.camera
//        let transform = currentCamera?.transform
    }
}

extension ViewController : CLLocationManagerDelegate {
    func setLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.distanceFilter = 1
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        self.lat = lat
        self.lon = lon
        self.lbl1.text = String("\(lat)\n\(lon)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
}
