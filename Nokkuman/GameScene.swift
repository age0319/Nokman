//
//  GameScene.swift
//  Nokkuman
//
//  Created by haru on 2020/07/08.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import SpriteKit
import GameplayKit

enum ZPositions: Int {
    case background
    case foreground
    case player
    case otherNodes
}

class GameScene: SKScene {
    
    let nokkuman = Nokkuman()
    let ground = Ground()
        
    override func didMove(to view: SKView) {
//
//        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
//        print(self.frame)
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        nokkuman.zPosition = CGFloat(ZPositions.player.rawValue)
        self.addChild(nokkuman)
        
        ground.createGround(frameSize: self.size)
        ground.zPosition = CGFloat(ZPositions.background.rawValue)
        self.addChild(ground)
        
        setupButtons()
        
    }
    
    func setupButtons(){
        // 四角形の大きさを決める
        let Rect = CGRect(x: 0, y: 0, width: 40, height: 40)
        // ovalInを指定すると円を作成する
        let circle = UIBezierPath(ovalIn: Rect)
        
        let leftMove = SKShapeNode(path: circle.cgPath, centered: true)
        
        leftMove.position = CGPoint(x:70, y:35)
        
        leftMove.name = "Left"
        
        leftMove.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        addChild(leftMove)
        
        let rightMove = SKShapeNode(path: circle.cgPath, centered: true)
        
        rightMove.position = CGPoint(x:120, y:35)
        
        rightMove.name = "Right"
        
        rightMove.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        addChild(rightMove)
        
        let jump = SKShapeNode(path: circle.cgPath, centered: true)
               
        jump.position = CGPoint(x:600, y:35)
        
        jump.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        jump.name = "Jump"
        
        addChild(jump)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチしたボタンによって処理を分ける
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if (node.name == "Left") {
                startLeftMove()
            } else if (node.name == "Right") {
                startRightMove()
            } else if ( node.name == "Jump") {
                
            }
        }
    }
    
    func startRightMove(){
        self.nokkuman.rightMove = true
        self.nokkuman.lookForward()
        self.nokkuman.startRunAnimation()
    }
    
    func stopRightMove(){
        self.nokkuman.rightMove = false
        self.nokkuman.startIdleAnimation()
    }
    
    func startLeftMove(){
        self.nokkuman.leftMove = true
        self.nokkuman.lookBackward()
        self.nokkuman.startRunAnimation()
    }
    
    func stopLeftMove(){
        self.nokkuman.leftMove = false
        self.nokkuman.startIdleAnimation()
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name == "Left" {
                stopLeftMove()
            } else if node.name == "Right"{
                stopRightMove()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        nokkuman.update()
    }
}
