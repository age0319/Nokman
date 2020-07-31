//
//  AlienPink.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/31.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class AlienPink:Enemy {
    
    let initialSize = CGSize(width: 44, height: 63)
    let alien_images = ["alienPink_walk1","alienPink_walk2","alienPink_hit"]
    var fireballAnimation = SKAction()
    var flappingAndFire = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        self.physicsBody?.mass = 20
        self.life = 30
        
        images = alien_images
        createMoveAnimation()
        createDieAnimation()
        run(animationAndMove)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func createMoveAnimation() {
        let Frames:[SKTexture] =
            [
                textureAtlas.textureNamed(images[0]),
                textureAtlas.textureNamed(images[1])
        ]
        
        let Action = SKAction.animate(with: Frames, timePerFrame: 0.14)
        
        flappingAnimation = SKAction.repeatForever(Action)
        
        let flipLeft = SKAction.scaleX(to: -1, duration: 0.05)
        let moveLeft = SKAction.move(by: CGVector(dx: -100, dy: 0), duration: 2)
        let flipRight = SKAction.scaleX(to: 1, duration: 0.05)
        let moveRight = SKAction.move(by: CGVector(dx: 100, dy: 0), duration: 2)
        
        movingAnimation = SKAction.repeatForever(SKAction.sequence([flipLeft,moveLeft,flipRight,moveRight]))
        
        animationAndMove = SKAction.group([flappingAnimation,movingAnimation])
    }
    
    override func takeDamage(damage: Int) {
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
