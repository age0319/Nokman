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
    let initialPosition = CGPoint(x: 200, y: 100)
    var textureAtlas = SKTextureAtlas(named:"Enemies")
    var frogAnimation = SKAction()
    
    let runSpeed:CGFloat = -100
    
    init() {
        super.init(texture: SKTexture(imageNamed: "fly"), color: .clear, size: initialSize)
        
        self.position = initialPosition
        
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
            
        self.physicsBody?.mass = 1
        
        self.physicsBody?.allowsRotation = false
        
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        createAnimations()
        
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.velocity = CGVector(dx: runSpeed, dy: 0)
        
        self.run(frogAnimation)
    }
    
    func createAnimations() {
        let frogFrames:[SKTexture] =
            [
                textureAtlas.textureNamed("fly"),
                textureAtlas.textureNamed("fly_move")
            ]
        
        let frogAction = SKAction.animate(with: frogFrames, timePerFrame: 0.14)
        frogAnimation = SKAction.repeatForever(frogAction)
    
    }
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
}
