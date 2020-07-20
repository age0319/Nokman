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
    
    let initialSize = CGSize(width: 42, height: 42)
    var textureAtlas = SKTextureAtlas(named:"Enemies")
    var flyAnimation = SKAction()
    var movingAnimation = SKAction()
    var dieAnimation = SKAction()
    var flyAndMove = SKAction()
    
    let runSpeed:CGFloat = 100
    
    var life = 5
    
    init() {
        super.init(texture: SKTexture(imageNamed: "fly"), color: .clear, size: initialSize)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
            
        self.physicsBody?.mass = 1
        
        self.physicsBody?.allowsRotation = false
        
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        createAnimations()
        
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        
        self.run(flyAndMove)
    }
    
    func createAnimations() {
        let Frames:[SKTexture] =
            [
                textureAtlas.textureNamed("fly"),
                textureAtlas.textureNamed("fly_move")
            ]
        
        let Action = SKAction.animate(with: Frames, timePerFrame: 0.14)
        
        flyAnimation = SKAction.repeatForever(Action)
        
        let flipLeft = SKAction.scaleX(to: 1, duration: 0.05)
        let moveLeft = SKAction.move(by: CGVector(dx: -100, dy: 0), duration: 2)
        let flipRight = SKAction.scaleX(to: -1, duration: 0.05)
        let moveRight = SKAction.move(by: CGVector(dx: 100, dy: 0), duration: 2)
        
        movingAnimation = SKAction.repeatForever(SKAction.sequence([flipLeft,moveLeft,flipRight,moveRight]))
        
        flyAndMove = SKAction.group([flyAnimation,movingAnimation])
        
        let startDie = SKAction.run {
            self.texture = self.textureAtlas.textureNamed("fly_dead")
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            // 死んだら落下するようにする
            self.physicsBody?.affectedByGravity = true
            
            // 判定を無効に
            self.physicsBody?.collisionBitMask = 0
            self.physicsBody?.categoryBitMask = 0
        }
        
        let fadeout = SKAction.fadeOut(withDuration: 1)
        
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
    
    func takeDamage(){
        life -= 1
        
        if life == 0{
            die()
        }else{
            self.removeAllActions()
            self.texture = SKTexture(imageNamed: "fly_dead")
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 0))
            let wait = SKAction.wait(forDuration: 1)
            self.run(SKAction.sequence([wait,flyAndMove]))
        }
    }
}
