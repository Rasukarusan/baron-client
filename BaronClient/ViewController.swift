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

class ViewController: UIViewController {
    let NODE_NAME_BARON : String = "baron"
    var arSceneView = ARSCNView()    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildUI()
        self.registTapGesture()
    }

    override func viewDidAppear(_ animated: Bool) {
        let configuration = ARWorldTrackingConfiguration()
        self.arSceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.arSceneView.session.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
