//
//  GameScene.swift
//  Nokkuman
//
//  Created by haru on 2020/07/08.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let nokkuman = Nokkuman()
        
    override func didMove(to view: SKView) {
        
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        self.addChild(nokkuman)
        
        setupButtons()
        
        //ゲームシーンにも物理エンジンを設定。フレームの隅に行くと折り返す。
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
    }
    
    func setupButtons(){
        // 四角形の大きさを決める
        let Rect = CGRect(x: 0, y: 0, width: 40, height: 40)
        // ovalInを指定すると円を作成する
        let circle = UIBezierPath(ovalIn: Rect)
        
        let leftMove = SKShapeNode(path: circle.cgPath, centered: true)
        
        leftMove.position = CGPoint(x:70, y:35)
        
        leftMove.name = "Left"
        
        addChild(leftMove)
        
        let rightMove = SKShapeNode(path: circle.cgPath, centered: true)
        
        rightMove.position = CGPoint(x:120, y:35)
        
        rightMove.name = "Right"
        
        addChild(rightMove)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチしたボタンによって処理を分ける
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if (node.name == "Left") {
                self.nokkuman.lookBackward()
                self.nokkuman.startRunAnimation()
                self.nokkuman.physicsBody?.velocity = CGVector(dx: -100, dy: 0)
            } else if (node.name == "Right") {
                self.nokkuman.lookForward()
                self.nokkuman.startRunAnimation()
                self.nokkuman.physicsBody?.velocity = CGVector(dx: 100, dy: 0)
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if (node.name == "Left" || node.name == "Right") {
                self.nokkuman.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
                self.nokkuman.startIdleAnimation()
            }
        }
    }
}
