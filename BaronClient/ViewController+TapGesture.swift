import UIKit
import ARKit
import SceneKit

extension ViewController : UIGestureRecognizerDelegate {        
    
    /*
     * 画面タップ検出
     */
    func registTapGesture() {
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped(_:)))
        tapGesture.delegate = self
        self.arSceneView.addGestureRecognizer(tapGesture)
    }
    
    /**
     * タップした画面上の位置情報から、現実世界の位置を取得
     *
     * @param CGPoint タップした位置
     * @return SCNVector3 x,y,zで記された現実世界の位置
     */
    func getRealPoint(tapPoint : CGPoint) -> SCNVector3 {
        let results : [ARHitTestResult] = self.arSceneView.hitTest(tapPoint, types: .estimatedHorizontalPlane)
        guard let hitPoint = results.first else {
            return SCNVector3.init(0,0,0)
        }
        let point = SCNVector3.init(hitPoint.worldTransform.columns.3.x, hitPoint.worldTransform.columns.3.y, hitPoint.worldTransform.columns.3.z)
        return point
    }
    
    /**
     * タップ時の処理
     */
    @objc func tapped(_ sender: UITapGestureRecognizer){
        let tapPoint : CGPoint = sender.location(in: self.arSceneView)
        let point : SCNVector3 = self.getRealPoint(tapPoint: tapPoint)
        if point.x == 0 && point.y == 0 && point.z == 0 {
            return
        }
        if self.existNode() {
            self.moveNode(nodeName: self.NODE_NAME_BARON, position: point)
            self.lbl2.text = String("x:\(point.x)\ny:\(point.y)\nz:\(point.z)")
            return
        }
        self.arSceneView.scene.rootNode.addChildNode(makeNode(point: point))
    }
    
    /**
     * ノードを作成
     */
    func makeNode(point : SCNVector3) -> SCNNode{
        let node : SCNNode =  SCNNode(named:"art.scnassets/Samba Dancing.dae")
        // scnから読み込むとでかすぎるので0.1倍にする
        node.scale = SCNVector3.init(0.001, 0.001, 0.001)
        node.name = self.NODE_NAME_BARON
        node.position = point
        return node
    }
    
    /**
     * 指定した場所にノードを移動
     *
     * @param String ノードの一意名
     * @param SCNVector3 移動させたい場所
     */
    private func moveNode(nodeName : String, position : SCNVector3) {
        // 上下に動かしたくないのでy軸は0に固定
        let position = SCNVector3Make(position.x, 0, position.z)
        self.arSceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == nodeName {
                let action = SCNAction.move(to: position, duration: 1.0)
                node.runAction(action)
            }
        }
    }
    
    /**
     * すでにノードが設置済みか判定
     *
     * @return Bool true:ノードが存在する, false: ノードが存在しない
     */
    private func existNode() -> Bool{
        var exist = false
        self.arSceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == self.NODE_NAME_BARON {
                exist = true
            }
        }
        return exist
    }
}

