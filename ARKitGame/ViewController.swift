//
//  ViewController.swift
//  ARKitGameExample
//
//  Created by 三浦亮太朗 on 2017/07/02.
//  Copyright © 2017年 三浦亮太朗. All rights reserved.
//

import UIKit
import QuartzCore
import ARKit

class ViewController: UIViewController {

    @IBAction func ResetButton(_ sender: Any) {
        startAgain()
    }
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    var timer : Timer!
    var timeCount : Float = 30
    
    var counter:Int = 0 {
        didSet {
            counterLabel.text = "\(counter)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        
        sceneView.scene = scene
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingSessionConfiguration()
        
        sceneView.session.run(configuration)
        
        addObject()
        
        startAgain()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        timer.invalidate()
    }
    
    @objc func onUpdate(timer : Timer){
        
        timeCount -= 1
        
        let str = String(format: "%.0f", timeCount)
        
        timerLabel.text = str
        
        if timeCount < 0{
            gameOver()
        }
        
    }
    
    func gameOver(){
        timer.invalidate()
        timerLabel.textColor = UIColor.red
        timerLabel.text = "GAME OVER"
        counterLabel.textColor = UIColor.red
        
    }
    
    func startAgain() {
        if timer != nil{
            timer.invalidate()
        }
        counterLabel.textColor = UIColor.black
        timerLabel.textColor = UIColor.black
        counter = 0
        timeCount = 31
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.onUpdate(timer:)), userInfo: nil, repeats: true)
        
    }
    
    
    
    func addObject() {
        let ship = SpaceShip()
        ship.loadModal()
        
        let xPos = randomPosition(lowerBound: -1.5, upperBound: 1.5)
        let yPos = randomPosition(lowerBound: -1.5, upperBound: 1.5)
        
        ship.position = SCNVector3(xPos, yPos, -1)
        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        ship.runAction(SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0, z: CGFloat(arc4random() % 10), duration: 10)))
        sceneView.scene.rootNode.addChildNode(ship)
        
    }
    
    func randomPosition (lowerBound lower:Float, upperBound upper:Float) -> Float {
        return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: sceneView)
            
            let hitList = sceneView.hitTest(location, options: nil)
            
            if let hitObject = hitList.first {
                let node = hitObject.node
                
                if node.name == "ARShip" {
                    SCNTransaction.commit()
                    if timeCount > 0 {
                        counter += 1
                        node.removeFromParentNode()
                        addObject()
                    }
                }
            }
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

