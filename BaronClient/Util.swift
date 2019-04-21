//
//  Utility.swift
//  BaronClient
//
//  Created by tanaka naoto on 2019/04/21.
//  Copyright © 2019年 tanaka.naoto. All rights reserved.
//

import SceneKit


extension ViewController {
    func rotateArrowToCat() {
        self.arSceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == self.NODE_NAME_BARON {
                if let camera = self.arSceneView.pointOfView {
                    let invMat :SCNMatrix4 = SCNMatrix4Invert(camera.transform)
                    let x = node.position.x
                    let y = node.position.y
                    let z = node.position.z
                    let transPosition :SCNVector3 = SCNVector3(x: x*invMat.m11 + y*invMat.m21 + z*invMat.m31, y: x*invMat.m12 + y*invMat.m22 + z*invMat.m32, z: x*invMat.m13 + y*invMat.m23 + z*invMat.m33)
                    let angle = (-1) * atan2(transPosition.y - camera.position.y, transPosition.x - camera.position.x)
                    DispatchQueue.main.async {
                        self.inputX.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
                    }
                }
            }
        }
    }
}
