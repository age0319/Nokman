//
//  Ground.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/18.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

import SpriteKit

class Ground:  SKSpriteNode{
    
    func createGround(frameSize:CGSize){
//        let g = CGRect(x: 0, y: -frameSize.height/2, width: frameSize.width*5, height: 50)
        let g = SKSpriteNode(color: .brown, size: CGSize(width: frameSize.width*5, height: 100))
        g.position = CGPoint(x: 0, y: -frameSize.height/2)
        g.physicsBody = SKPhysicsBody(rectangleOf: g.size)
        g.zPosition = CGFloat(ZPositions.foreground.rawValue)
        g.physicsBody?.isDynamic = false
        g.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
        self.addChild(g)
    }
    
}
