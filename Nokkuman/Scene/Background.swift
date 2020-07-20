//
//  Background.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/13.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class Background:  SKSpriteNode{
    
    var initialSize = CGSize()
    
    func craeteBackground(frameSize:CGSize, number:Int){
        initialSize = frameSize
        
        for i in 0..<number{
            let bg = SKSpriteNode(texture: SKTexture(imageNamed: "Cartoon_Forest_BG_01"), color: .clear, size: initialSize)
            bg.position = CGPoint(x: CGFloat(i) * initialSize.width, y: 0)
            bg.zPosition = CGFloat(ZPositions.background.rawValue)
            
            self.addChild(bg)
        }
        
        let LeftUnderPoint = CGPoint(x: -frameSize.width/2, y: -frameSize.height/2)
        let LeftTopPoint = CGPoint(x: -frameSize.width/2, y: frameSize.height/2)
        
        self.physicsBody = SKPhysicsBody(edgeFrom: LeftUnderPoint, to: LeftTopPoint)
    }
}
