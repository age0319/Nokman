//
//  Ground.swift
//  Nokkuman
//
//  Created by haru on 2020/07/10.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode {
    
    let Height:CGFloat = 60
    
    func createGround(frameSize:CGSize,num:Int){
        
        let halfY = frameSize.height/2
        let rightEdge = (CGFloat(num)*frameSize.width) - (frameSize.width/2)
        
        // 地面の高さ分、エッジを作る
        let pointTopLeft = CGPoint(x: -frameSize.width/2, y: Height - halfY)
        let pointTopRight = CGPoint(x: rightEdge, y: Height - halfY)
        
        self.physicsBody = SKPhysicsBody(edgeFrom: pointTopLeft, to: pointTopRight)
    }
}
