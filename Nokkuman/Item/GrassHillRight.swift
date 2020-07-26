//
//  GrassHillRight.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/26.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class GrassHillRight: SKSpriteNode {
    let initialSize = CGSize(width: 42, height: 42)
        
    init() {
        super.init(texture: SKTexture(imageNamed: "grassHill_right"), color: .clear, size: initialSize)
                
           
        self.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -initialSize.width/2, y: -initialSize.height/2), to: CGPoint(x: initialSize.width/2, y: initialSize.height/2))

        self.physicsBody?.friction = 0
            
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
        
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
