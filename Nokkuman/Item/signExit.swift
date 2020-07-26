//
//  signExit.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/26.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

import SpriteKit

class signExit: SKSpriteNode {
    let initialSize = CGSize(width: 42, height: 42)
        
    init() {
        super.init(texture: SKTexture(imageNamed: "signExit"), color: .clear, size: initialSize)
                
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
                
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.exit.rawValue
        
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
