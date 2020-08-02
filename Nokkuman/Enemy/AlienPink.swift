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
    var isMoving = false
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        self.life = 30
        self.physicsBody?.affectedByGravity = true
        
        images = alien_images
        
        self.xScale = -1
        
        createSwitchAnimation()
        createMoveAnimation()
        createDieAnimation()
        
        self.run(switchAnimation)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startMove(){
        if isMoving == false{
            isMoving = true
            self.run(switchAndMove)
        }
    }
    
    override func createMoveAnimation(){
        
        let rightTop = CGPoint(x: sceneSize.width/2 - 30, y: sceneSize.height/2 - 30)
        let leftTop = CGPoint(x: -sceneSize.width/2 + 30, y: sceneSize.height/2 - 30)
        let centerTop = CGPoint(x: 0, y: sceneSize.height/2 - 30)
        let rightGround = CGPoint(x: sceneSize.width/2 - 30, y: -sceneSize.height/2 + groundHeight)
        let leftGround = CGPoint(x: -sceneSize.width/2 + 30, y: -sceneSize.height/2 + groundHeight)
        
        // 右に移動する
        let moveLeftGround = SKAction.group([
            SKAction.scaleX(to: -1, duration: 0.05),
            SKAction.move(to: leftGround, duration: 2)
        ])
        
        //左に移動する
        let moveRightGround = SKAction.group([
            SKAction.scaleX(to: 1, duration: 0.05),
            SKAction.move(to: rightGround, duration: 2)
        ])
                
        let moveRightTop = SKAction.move(to: rightTop, duration: 0)
        
        let moveCenterTop = SKAction.move(to: centerTop, duration: 0)
                
        let moveLeftTop = SKAction.move(to: leftTop, duration: 0)
        
        let wait = SKAction.wait(forDuration: 1.5)
        
        //右上に移動して落ちる
        let fallingFromRight = SKAction.sequence([moveRightTop,wait])
        
        //左上に移動して落ちる
        let fallingFromleft = SKAction.group([moveLeftTop,wait])
        
        // 中央上に移動して落ちる
        let fallingFromCenter = SKAction.group([moveCenterTop,wait])
        
        movingAnimation = SKAction.repeatForever(SKAction.sequence([
            moveLeftGround,fallingFromRight,fallingFromleft,moveRightGround,fallingFromCenter
        ]))
        
        switchAndMove = SKAction.group([switchAnimation,movingAnimation])
    }
    
}
