//
//  Enemy.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/22.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode {
    var textureAtlas = SKTextureAtlas(named:"Enemies")
    var flappingAnimation = SKAction()
    var movingAnimation = SKAction()
    var dieAnimation = SKAction()
    var animationAndMove = SKAction()
    
    let runSpeed:CGFloat = 100
    
    var life = 5
    
    var images = [String]()
    
    // SKSpriteNodeを継承して敵としての初期設定をする
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        
        self.physicsBody?.mass = 1
        
        self.physicsBody?.allowsRotation = false
        
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        
        self.physicsBody?.collisionBitMask = ~(PhysicsCategory.fireball.rawValue |
            PhysicsCategory.bigbullet.rawValue)
    }
    
    func createAnimations() {
        let Frames:[SKTexture] =
            [
                textureAtlas.textureNamed(images[0]),
                textureAtlas.textureNamed(images[1])
        ]
        
        let Action = SKAction.animate(with: Frames, timePerFrame: 0.14)
        
        flappingAnimation = SKAction.repeatForever(Action)
        
        let flipLeft = SKAction.scaleX(to: 1, duration: 0.05)
        let moveLeft = SKAction.move(by: CGVector(dx: -100, dy: 0), duration: 2)
        let flipRight = SKAction.scaleX(to: -1, duration: 0.05)
        let moveRight = SKAction.move(by: CGVector(dx: 100, dy: 0), duration: 2)
        
        movingAnimation = SKAction.repeatForever(SKAction.sequence([flipLeft,moveLeft,flipRight,moveRight]))
        
        animationAndMove = SKAction.group([flappingAnimation,movingAnimation])
        
        let startDie = SKAction.run {
            self.texture = self.textureAtlas.textureNamed(self.images[2])
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
    
    func takeDamage(damage:Int){
        life -= damage
        
        if life <= 0{
            die()
        }else{
            self.removeAllActions()
            self.texture = SKTexture(imageNamed: images[2])
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 0))
            let wait = SKAction.wait(forDuration: 1)
            self.run(SKAction.sequence([wait,animationAndMove]))
        }
    }
}
