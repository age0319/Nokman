//
//  Ground.swift
//  Nokkuman
//
//  Created by haru on 2020/07/10.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode {
    
    let Height:CGFloat = 120
    
    func createGround(frameSize:CGSize,num:Int){
        
        let halfY = frameSize.height/2
        
        var i = 0
        while i < num {
            let gr = SKSpriteNode(color: .green, size: CGSize(width: frameSize.width, height: Height))
            gr.position = CGPoint(x: CGFloat(i) * frameSize.width,y: -halfY)
            self.addChild(gr)
            i += 1
        }
        
        let rightEdge = (CGFloat(num)*frameSize.width) - (frameSize.width/2)
        // 地面の高さ分、エッジを作る
        let pointTopLeft = CGPoint(x: -frameSize.width/2, y: Height/2 - halfY)
        let pointTopRight = CGPoint(x: rightEdge, y: Height/2 - halfY)
        print(pointTopRight)
        
        self.physicsBody = SKPhysicsBody(edgeFrom: pointTopLeft, to: pointTopRight)
    }
    
}
