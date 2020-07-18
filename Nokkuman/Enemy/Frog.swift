//
//  Frog.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/15.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class Frog:SKSpriteNode{
    
    let initialSize = CGSize(width: 42, height: 42)
    var textureAtlas = SKTextureAtlas(named:"Enemies")
    var frogAnimation = SKAction()
    var dieAnimation = SKAction()
    
    let runSpeed:CGFloat = -100
    
    init() {
        super.init(texture: SKTexture(imageNamed: "frog"), color: .clear, size: initialSize)
        
        self.name = "frog"
        
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
            
        self.physicsBody?.mass = 1
        
        self.physicsBody?.allowsRotation = false
        
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        createAnimations()
        
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.velocity = CGVector(dx: runSpeed, dy: 0)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
                
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
        
        let startDie = SKAction.run {
            self.texture = self.textureAtlas.textureNamed("frog_dead")
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            // 判定を無効に
            self.physicsBody?.collisionBitMask = 0
            self.physicsBody?.categoryBitMask = 0
        }
        
        let fadeout = SKAction.fadeOut(withDuration: 10)
        
        let endDie = SKAction.removeFromParent()
        
        dieAnimation = SKAction.sequence([startDie,fadeout,endDie])
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func die(){
        self.removeAllActions()
        self.run(dieAnimation)
    }
    
}
