//
//  ViewController.swift
//  ARKitGameExample
//
//  Created by 三浦亮太朗 on 2017/07/02.
//  Copyright © 2017年 三浦亮太朗. All rights reserved.
//

import ARKit

class SpaceShip: SCNNode {
    
    func loadModal() {
        guard let virtualOjectScene = SCNScene(named: "art.scnassets/ship.scn") else {return}
        let wrapperNode = SCNNode()
        for child in virtualOjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)
        
    }
    
}
