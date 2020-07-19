//
//  Shot.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/14.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class Shot:SKSpriteNode{
    
    var backword:Bool = false
    var shotSpeed:CGFloat = 600
    let shotspace:CGFloat = 5
    let initialSize = CGSize(width: 10, height: 10)
    
    init(pos:CGPoint,bw:Bool){
        super.init(texture: SKTexture(imageNamed: "shot"), color:.clear,size: initialSize)

        self.backword = bw
        
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
        
        self.physicsBody?.mass = 0.5
        
        self.physicsBody?.affectedByGravity = false
        
        if self.backword {
            self.xScale = -1
            self.position = CGPoint(x:pos.x - shotspace, y:pos.y)
        }else{
            self.position = CGPoint(x:pos.x + shotspace, y:pos.y)
        }
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.bullet.rawValue
        
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue |
            PhysicsCategory.box.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fire(){
        
        if self.backword {
            self.physicsBody?.applyImpulse(CGVector(dx: -shotSpeed, dy: 0))
        }else{
            self.physicsBody?.applyImpulse(CGVector(dx: shotSpeed, dy: 0))
        }
        //1秒経ったら弾を消す
        let wait = SKAction.wait(forDuration: 1)
        let endShot = SKAction.run {
            self.removeFromParent()
        }
        self.run(SKAction.sequence([wait,endShot]))
        
    }
    
}
