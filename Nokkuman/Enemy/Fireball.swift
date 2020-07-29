//
//  Fire.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/29.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class Fireball: SKSpriteNode {
    var shotSpeed:CGFloat = 200
    let shotspace:CGFloat = 5
    let initialSize = CGSize(width: 40, height: 40)
    var damage = 1
    
    init(pos:CGPoint){
        super.init(texture: SKTexture(imageNamed: "fireball"), color:.clear,size: initialSize)
        
        self.position = CGPoint(x:pos.x - shotspace, y:pos.y)
        
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
        
        self.physicsBody?.mass = 0.5
        
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.fireball.rawValue
        
        self.physicsBody?.contactTestBitMask = PhysicsCategory.nokman.rawValue
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fire(){
        self.physicsBody?.applyImpulse(CGVector(dx: -shotSpeed, dy: 0))
        let wait = SKAction.wait(forDuration: 1.5)
        let endShot = SKAction.run {
            self.removeFromParent()
        }
        self.run(SKAction.sequence([wait,endShot]))
    }
 }
