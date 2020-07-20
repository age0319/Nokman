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
    var bounceAnimation = SKAction()
    var dieAnimation = SKAction()
    var movingAnimation = SKAction()
    var bounceAndMoving = SKAction()
    
    let runSpeed:CGFloat = -100
    
    var life = 5
    
    init() {
        super.init(texture: SKTexture(imageNamed: "frog"), color: .clear, size: initialSize)
        
        self.name = "frog"
        
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
            
        self.physicsBody?.mass = 1
        
        self.physicsBody?.allowsRotation = false
        
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        createAnimations()
                
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        
        self.run(bounceAndMoving)
    }
    
    func createAnimations() {
        let frogFrames:[SKTexture] =
            [
                textureAtlas.textureNamed("frog"),
                textureAtlas.textureNamed("frog_move")
            ]
        
        let frogAction = SKAction.animate(with: frogFrames, timePerFrame: 0.14)
        bounceAnimation = SKAction.repeatForever(frogAction)
        
        let flipLeft = SKAction.scaleX(to: 1, duration: 0.05)
        let moveLeft = SKAction.move(by: CGVector(dx: -300, dy: 0), duration: 6)
        let flipRight = SKAction.scaleX(to: -1, duration: 0.05)
        let moveRight = SKAction.move(by: CGVector(dx: 300, dy: 0), duration: 6)
        
        movingAnimation = SKAction.repeatForever(SKAction.sequence([flipLeft,moveLeft,flipRight,moveRight]))
        
        bounceAndMoving = SKAction.group([bounceAnimation,movingAnimation])
        
        let startDie = SKAction.run {
            self.texture = self.textureAtlas.textureNamed("frog_dead")
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            // 判定を無効に
            self.physicsBody?.collisionBitMask = 0
            self.physicsBody?.categoryBitMask = 0
        }
        
        let fadeout = SKAction.fadeOut(withDuration: 3)
        
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
            self.texture = SKTexture(imageNamed: "frog_dead")
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 50))
            let wait = SKAction.wait(forDuration: 1)
            self.run(SKAction.sequence([wait,bounceAndMoving]))

        }
    }
    
   
}
