//
//  Bridge.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/30.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class Bridge: SKSpriteNode {
    let initialSize = CGSize(width: 42, height: 42)
        
    init() {
        super.init(texture: SKTexture(imageNamed: "bridgeB"), color: .clear, size: initialSize)
                
        self.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -initialSize.width/2, y: initialSize.height/2), to: CGPoint(x: initialSize.width/2, y: initialSize.height/2))
                
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
        
        let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 200), duration: 3)
        let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -200), duration: 3)
              
        let movingAnimation = SKAction.repeatForever(SKAction.sequence([moveUp,moveDown]))
        
        run(movingAnimation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
