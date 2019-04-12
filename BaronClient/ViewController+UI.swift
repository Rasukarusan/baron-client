import UIKit
import ARKit
import SceneKit

extension ViewController {
    
    func buildUI() {
        // ARViewの描画
        self.arSceneView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.arSceneView.center = self.view.center
        self.view.addSubview(self.arSceneView)
        
        // ARViewの設定
        let arSession = ARSession()
        self.arSceneView.session = arSession
        self.arSceneView.session.delegate = self
        
        // オブジェクト配置のためのシーンを追加
        let scene = SCNScene()
        self.arSceneView.scene = scene
        
        // デバッグ情報表示
        self.arSceneView.showsStatistics = true
        self.arSceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
                
        lbl1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width*0.8, height: 50)
        lbl1.center = CGPoint(x: self.view.frame.width/2, y: 100)
        lbl1.text = "latitude"
        lbl1.backgroundColor = .blue
        self.view.addSubview(lbl1)
        
        lbl2.frame = CGRect(x: 0, y: 0, width: self.view.frame.width*0.8, height: 50)
        lbl2.center = CGPoint(x: self.view.frame.width/2, y: 200)
        lbl2.text = "longitude"
        lbl2.backgroundColor = .red
        self.view.addSubview(lbl2)
    }
    
    // ステータスバーを非表示にする
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
}
