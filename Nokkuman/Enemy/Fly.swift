//
//  Fly.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/15.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

import SpriteKit

class Fly:SKSpriteNode {
    
    let initialSize = CGSize(width: 32, height: 32)
    var textureAtlas = SKTextureAtlas(named:"Enemies")
    var Animation = SKAction()
    var movingAnimation = SKAction()
    
    let runSpeed:CGFloat = 100
    
    init() {
        super.init(texture: SKTexture(imageNamed: "fly"), color: .clear, size: initialSize)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
            
        self.physicsBody?.mass = 1
        
        self.physicsBody?.allowsRotation = false
        
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        createAnimations()
        
        self.physicsBody?.affectedByGravity = false
        
        self.run(Animation)
        self.run(movingAnimation)
    }
    
    func createAnimations() {
        let Frames:[SKTexture] =
            [
                textureAtlas.textureNamed("fly"),
                textureAtlas.textureNamed("fly_move")
            ]
        
        let Action = SKAction.animate(with: Frames, timePerFrame: 0.14)
        
        Animation = SKAction.repeatForever(Action)
        
        let flipLeft = SKAction.scaleX(to: 1, duration: 0.05)
        let moveLeft = SKAction.move(by: CGVector(dx: -100, dy: 0), duration: 2)
        let flipRight = SKAction.scaleX(to: -1, duration: 0.05)
        let moveRight = SKAction.move(by: CGVector(dx: 100, dy: 0), duration: 2)
        
        movingAnimation = SKAction.repeatForever(SKAction.sequence([flipLeft,moveLeft,flipRight,moveRight]))
    
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
