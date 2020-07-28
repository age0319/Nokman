//
//  Frag.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/28.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class Flag: SKSpriteNode {
    
    let initialSize = CGSize(width: 42, height: 42)
        
    init() {
        super.init(texture: SKTexture(imageNamed: "flagRed1"), color: .clear, size: initialSize)
                
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
                
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.flag.rawValue
        
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
