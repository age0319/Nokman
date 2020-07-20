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

    let initialSize = CGSize(width: 42, height: 42)
    
    func createGround(frameSize:CGSize, number:Int){

        let groundWidth = frameSize.width * CGFloat(number)
        let requiredGrassNumber = Int(groundWidth / initialSize.width)
        
        print(groundWidth)
        print(requiredGrassNumber)
        
        for i in 0...requiredGrassNumber {
            let grass = SKSpriteNode(texture: SKTexture(imageNamed: "grass"), color: .clear, size: initialSize)
            grass.position = CGPoint(x: -frameSize.width/2 + CGFloat(i) * initialSize.width, y: -frameSize.height/2 + initialSize.height/2)
            grass.zPosition = CGFloat(ZPositions.foreground.rawValue)
            grass.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
            
            self.addChild(grass)
            }
        
        let leftTop = CGPoint(x: -frameSize.width/2, y: -frameSize.height/2 + initialSize.height)
        
        let rightTop = CGPoint(x: -frameSize.width/2 + CGFloat(requiredGrassNumber + 1) * initialSize.width, y: -frameSize.height/2 + initialSize.height)
        
        self.physicsBody = SKPhysicsBody(edgeFrom: leftTop, to: rightTop)
        
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
        
    }
    
}
