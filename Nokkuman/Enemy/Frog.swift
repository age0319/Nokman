//
//  Frog.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/15.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class Frog:SKSpriteNode {
    
    let initialSize = CGSize(width: 42, height: 42)
    var textureAtlas = SKTextureAtlas(named:"Enemies")
    var frogAnimation = SKAction()
    
    let runSpeed:CGFloat = -100
    
    init() {
        super.init(texture: SKTexture(imageNamed: "frog"), color: .clear, size: initialSize)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
            
        self.physicsBody?.mass = 1
        
        self.physicsBody?.allowsRotation = false
        
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        createAnimations()
        
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.velocity = CGVector(dx: runSpeed, dy: 0)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedNokman.rawValue
        
        self.run(frogAnimation)
    }
    
    func createAnimations() {
        let frogFrames:[SKTexture] =
            [
                textureAtlas.textureNamed("frog"),
                textureAtlas.textureNamed("frog_move")
            ]
        
        let frogAction = SKAction.animate(with: frogFrames, timePerFrame: 0.14)
        frogAnimation = SKAction.repeatForever(frogAction)
    
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
