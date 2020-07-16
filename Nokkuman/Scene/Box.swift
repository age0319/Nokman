//
//  Box.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/16.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import SpriteKit

class Box:SKSpriteNode {
    
    let initialSize = CGSize(width: 32, height: 32)
        
    init() {
        super.init(texture: SKTexture(imageNamed: "boxCrate"), color: .clear, size: initialSize)
                
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
            
        self.physicsBody?.mass = 1
        
        self.physicsBody?.allowsRotation = false
        
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.box.rawValue
        
        self.physicsBody?.isDynamic = false
                
        }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
