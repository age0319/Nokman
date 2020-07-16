//
//  Ground.swift
//  Nokkuman
//
//  Created by haru on 2020/07/10.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode {
    
    init(frameSize:CGSize,num:Int){
        
        let Height:CGFloat = 120
        let size = CGSize(width: frameSize.width * CGFloat(num), height: Height)
        let halfY = frameSize.height/2

        super.init(texture: nil, color: .clear, size: size)
        
        self.color = UIColor.green
        
        self.position = CGPoint(x: 0, y: -halfY)
        self.zPosition = CGFloat(ZPositions.foreground.rawValue)
                
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
