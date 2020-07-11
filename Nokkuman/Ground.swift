//
//  Ground.swift
//  Nokkuman
//
//  Created by haru on 2020/07/10.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode {
    
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "Ground")
    let tileSize = CGSize(width: 35, height: 60)
    
    func createGround(frameSize:CGSize){
        
        self.size = CGSize(width: frameSize.width, height: tileSize.height)
        
        let texture = textureAtlas.textureNamed("Ground")
        var tileCount = 0
        
        while CGFloat(tileCount) * tileSize.width < self.size.width {
            let tileNode = SKSpriteNode(texture: texture)
            tileNode.position.x = CGFloat(tileCount) * tileSize.width
            tileNode.size = tileSize
            // 当たり判定を左下にする
            tileNode.anchorPoint = CGPoint(x: 0, y: 0)
            self.addChild(tileNode)
            tileCount += 1
        }
        
        // 地面の高さ分、エッジを作る
        let pointTopLeft = CGPoint(x: 0, y: size.height)
        let pointTopRight = CGPoint(x: size.width, y: size.height)
        self.physicsBody = SKPhysicsBody(edgeFrom: pointTopLeft, to: pointTopRight)
        
    }
}
