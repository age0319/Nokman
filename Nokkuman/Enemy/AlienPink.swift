//
//  AlienPink.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/31.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class AlienPink:Enemy {
    
    let initialSize = CGSize(width: 44, height: 63)
    let sceneSize = CGSize(width: 812, height: 375)
    let groundHeight:CGFloat = 43
    let alien_images = ["alienPink_walk1","alienPink_walk2","alienPink_hit"]
    var fireballAnimation = SKAction()
    var flappingAndFire = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        self.life = 30
        self.physicsBody?.affectedByGravity = true
        
        images = alien_images
        
        createSwitchAnimation()
        createMoveAnimation()
        createDieAnimation()
        
        self.run(switchAndMove)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func createMoveAnimation(){
        
        let rightTop = CGPoint(x: sceneSize.width/2 - 30, y: sceneSize.height/2 - 30)
        let leftTop = CGPoint(x: -sceneSize.width/2 + 30, y: sceneSize.height/2 - 30)
        let rightUnder = CGPoint(x: sceneSize.width/2 - 30, y: -sceneSize.height/2 + groundHeight)
        let leftUnder = CGPoint(x: -sceneSize.width/2 + 30, y: -sceneSize.height/2 + groundHeight)
        
        // 右に移動する
        let moveToLeft = SKAction.group([
            SKAction.scaleX(to: -1, duration: 0.05),
            SKAction.move(to: leftUnder, duration: 2)
        ])
        
        //左に移動する
        let moveToRight = SKAction.group([
            SKAction.scaleX(to: 1, duration: 0.05),
            SKAction.move(to: rightUnder, duration: 2)
        ])
        
        let warpRightTop = SKAction.run {
            self.position = rightTop
        }
        
        let warpLeftTop = SKAction.run {
            self.position = leftTop
        }
        
        let wait = SKAction.wait(forDuration: 1.5)
        
        //右上に瞬間移動し落ちる
        let fallingFromRight = SKAction.group([
            warpRightTop,
            wait
        ])
        
        //左上に瞬間移動し落ちる
        let fallingFromleft = SKAction.group([
            warpLeftTop,
            wait
        ])
        
        movingAnimation = SKAction.repeatForever(SKAction.sequence([
            moveToLeft,fallingFromRight,fallingFromleft,moveToRight
        ]))
        
        switchAndMove = SKAction.group([switchAnimation,movingAnimation])
    }
    
    
}
