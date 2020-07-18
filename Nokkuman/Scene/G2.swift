//
//  G2.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/18.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

import SpriteKit

class G2:  SKSpriteNode{
      
    let initialSize = CGSize(width: 812, height: 42)
            
    init() {
        super.init(texture: SKTexture(imageNamed: "grass"), color: .clear, size: initialSize)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
        
        self.physicsBody?.mass = 1
        
        self.zPosition = CGFloat(ZPositions.foreground.rawValue)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
        
        self.physicsBody?.isDynamic = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
