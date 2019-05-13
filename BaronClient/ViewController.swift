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
import Lottie

class ViewController: UIViewController {
    let NODE_NAME_BARON : String = "baron"
    var arSceneView = ARSCNView()
    var initialAnchor : ARPlaneAnchor!
    var loadAnimeView = LOTAnimationView()
    var meowAnimeView = LOTAnimationView()
    let arrowLbl = UILabel()
    let lbl1 = UILabel()
    let lbl2 = UILabel()
    let inputX = UITextField()
    let inputY = UITextField()
    
    private var isFloorRecognized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildUI()
        self.registTapGesture()   
    }

    private func addCat() {
        APIClient.getCat { cat in
            let point = self.convertCatAxisToAR(x: cat.locale.next_x_grid, z: cat.locale.next_y_grid)
            self.arSceneView.scene.rootNode.addChildNode(self.makeNode(point: point))
        }
    }

    private func runTimerForUpdateCat() {
        Timer.scheduledTimer(timeInterval: 1,
            target: self,
            selector: #selector(ViewController.updateCat),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func updateCat() {
        DispatchQueue.main.async {
            APIClient.getCat(completion: { (cat) in
                let points = self.convertCatAxisToAR(x: cat.locale.next_x_grid, z: cat.locale.next_y_grid)
                self.moveNode(nodeName: self.NODE_NAME_BARON, position: points)
            })
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
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        self.meow()
        if !isFloorRecognized {
            self.hideLoading()
            self.initialAnchor = planeAnchor
            arSceneView.debugOptions = []
            isFloorRecognized = true
            self.addCat()
            // renderは別スレッドで動いているためメインスレッド内でタイマーを発火させる
            DispatchQueue.main.async {
                self.runTimerForUpdateCat()
            }
        }
    }
}
