//
//  SCNNode.swift
//  BaronClient
//
//  Created by tanaka.naoto on 2019/03/29.
//  Copyright © 2019年 tanaka.naoto. All rights reserved.
//

import SceneKit

extension SCNNode {
    
    /**
     * .scnファイルをSCNNodeで読み込む
     * ex.) let node : SCNNode =  SCNNode(named:"art.scnassets/cat.scn")
     */
    convenience init(named name: String) {
        self.init()
        
        guard let scene = SCNScene(named: name) else {
            return
        }
        
        for childNode in scene.rootNode.childNodes {
            addChildNode(childNode)
        }
    }
    
}
