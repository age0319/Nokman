//
//  AlienGreen.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/08/05.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class AlienGreen:Enemy {
    
    let initialSize = CGSize(width: 44, height: 63)
    var sceneSize = CGSize(width: 812, height: 375)
    let groundHeight:CGFloat = 43
    let stage = "stage1"
    
    let alien_images = ["alienGreen_walk1","alienGreen_walk2","alienGreen_hit"]
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        
        self.life = 30
        
        images = alien_images
    
        createSwitchAnimation()
        createMoveAnimation()
        createDieAnimation()
    
        run(switchAndMove)
         
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func createMoveAnimation(){
        
        
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
        
        movingAnimation = SKAction.repeatForever(SKAction.sequence([
            moveLeftGround,moveRightGround
        ]))
        
        switchAndMove = SKAction.group([switchAnimation,movingAnimation])
    }
    
    override func die() {
        self.removeAllActions()
        self.run(dieAnimation)
        
        if let gameScene = self.scene as? GameScene{
            gameScene.gameClear()
            SaveData().save(key: stage, value: true)
        }
    }
    
}
