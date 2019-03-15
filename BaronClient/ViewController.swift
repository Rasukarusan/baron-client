//
//  ViewController.swift
//  BaronClient
//
//  Created by tanaka.naoto on 2019/03/15.
//  Copyright © 2019年 tanaka.naoto. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    var arSceneView = ARSCNView()
    
    // ステータスバーを非表示にする
    override var prefersStatusBarHidden: Bool { return true }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        setTapGesture()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func buildUI() {
        // ARViewの描画
        self.arSceneView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.arSceneView.center = self.view.center
        self.view.addSubview(self.arSceneView)
        
        // ARViewの設定
        let arSession = ARSession()
        self.arSceneView.session = arSession
        
        // デバッグ情報表示
        self.arSceneView.showsStatistics = true
        self.arSceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
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
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : UIGestureRecognizerDelegate {
    
    func setTapGesture() {
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped(_:)))
        tapGesture.delegate = self
        self.arSceneView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer){
        let tapPoint : CGPoint = sender.location(in: self.arSceneView)
        print(tapPoint)
    }
}

