//
//  Bee.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/29.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class Bee:Enemy {
    
    let initialSize = CGSize(width: 42, height: 42)
    let bee_images = ["bee","bee_move","bee_dead"]
    var fireballAnimation = SKAction()
    var flappingAndFire = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        //重くしないと弾の反動をうける
        self.physicsBody?.mass = 20
        images = bee_images
        createAnimations()
        run(flappingAnimation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
            self.run(SKAction.sequence([wait,flappingAnimation]))
        }
    }
    
}
