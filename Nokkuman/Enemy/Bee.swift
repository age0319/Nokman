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
        
        self.physicsBody?.isDynamic = false
        
        images = bee_images
              
        createSwitchAnimation()
        createDieAnimation()
        
        self.run(switchAnimation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func shotFireball(){
        let absolutePosition = self.parent!.convert(self.position, from: self.parent!)
        let fireball = Fireball(pos: absolutePosition)
        self.parent!.addChild(fireball)
        fireball.fire()
    }

}
