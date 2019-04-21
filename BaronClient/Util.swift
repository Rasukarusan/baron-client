//
//  Utility.swift
//  BaronClient
//
//  Created by tanaka naoto on 2019/04/21.
//  Copyright © 2019年 tanaka.naoto. All rights reserved.
//

import SceneKit

extension ViewController {
    
    func closeKeyborad() {
        self.inputX.resignFirstResponder()
        self.inputY.resignFirstResponder()
    }
    
    /**
     * アラート表示
     *
     * @param String message
     * @return void
     */
    func showAlert(message:String) {
        let alert: UIAlertController = UIAlertController(title: "にゃーん", message: message, preferredStyle:  .alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    /**
     * ノードとカメラとの距離を取得
     *
     * @param SCNVector3 nodePosision
     * @return Float 距離(m)
     */
    func getDistance(nodePosition: SCNVector3) -> Float {
        if let camera = self.arSceneView.pointOfView {
            let startPosition = SCNVector3Make(nodePosition.x, nodePosition.y, nodePosition.z)
            let endPosition = SCNVector3Make(camera.position.x, camera.position.y, camera.position.z)
            let position = SCNVector3Make(endPosition.x - startPosition.x, endPosition.y - startPosition.y, endPosition.z - startPosition.z)
            let distance = sqrt(position.x * position.x + position.y * position.y + position.z * position.z)
            return distance
        }
        return 0.0
    }
    
    /**
     * 対象ノードの方向へ矢印を回転
     *     
     * @return void
     */
    func rotateArrowToCat() {
        if let node = self.arSceneView.scene.rootNode.childNode(withName: self.NODE_NAME_BARON, recursively: true) {    
            if let camera = self.arSceneView.pointOfView {
                let invMat :SCNMatrix4 = SCNMatrix4Invert(camera.transform)
                let x = node.position.x
                let y = node.position.y
                let z = node.position.z
                let transPosition :SCNVector3 = SCNVector3(
                    x: x*invMat.m11 + y*invMat.m21 + z*invMat.m31,
                    y: x*invMat.m12 + y*invMat.m22 + z*invMat.m32,
                    z: x*invMat.m13 + y*invMat.m23 + z*invMat.m33
                )
                let angle = (-1) * atan2(transPosition.y - camera.position.y, transPosition.x - camera.position.x)
                DispatchQueue.main.async {
                    self.arrowLbl.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
                }
            }
        }
    }
    
    func createLineNode(startPosition: SCNVector3, endPosition: SCNVector3, color: UIColor) -> SCNNode {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [startPosition, endPosition])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        let line = SCNGeometry(sources: [source], elements: [element])
        line.firstMaterial?.lightingModel = SCNMaterial.LightingModel.blinn
        let lineNode = SCNNode(geometry: line)
        lineNode.geometry?.firstMaterial?.diffuse.contents = color
        lineNode.name = "line"
        return lineNode
    }
    
    func drawLine() {
        if let lineNode = self.arSceneView.scene.rootNode.childNode(withName: "line", recursively: true) {
            lineNode.removeFromParentNode()
        }
        if let camera = self.arSceneView.pointOfView {
            let startPosixion = SCNVector3Make(self.initialAnchor.transform.columns.3.x, self.initialAnchor.transform.columns.3.y, self.initialAnchor.transform.columns.3.z)
            let endPosision = SCNVector3Make(camera.position.x, camera.position.y, camera.position.z)
            let line = createLineNode(startPosition: startPosixion, endPosition: endPosision, color: .red)
            arSceneView.scene.rootNode.addChildNode(line)
        }
    }
}
