//
//  BoxItem.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/23.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class BoxItem: SKSpriteNode {
    
    let initialSize = CGSize(width: 42, height: 42)
        
    init() {
        super.init(texture: SKTexture(imageNamed: "boxItem"), color: .clear, size: initialSize)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
        
        self.physicsBody?.mass = 1
        
        self.physicsBody?.allowsRotation = false
        
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.box.rawValue
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func explode(position:CGPoint,scene:SKScene){
        var emitter = SKEmitterNode(fileNamed: "CrateExplosion")!
        emitter.position = position
        scene.addChild(emitter)
        
        emitter = SKEmitterNode(fileNamed: "HeartExplosion")!
        emitter.position = position
        scene.addChild(emitter)
    }
}
