//
//  Spike.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/23.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

import SpriteKit

class Spike: SKSpriteNode {
    let initialSize = CGSize(width: 42, height: 42)
        
    init() {
        super.init(texture: SKTexture(imageNamed: "spikes"), color: .clear, size: initialSize)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: initialSize.width, height: 1))
        
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
        
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
