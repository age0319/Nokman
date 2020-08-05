//
//  AlienBlue.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/08/04.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class AlienBlue:Enemy {
    
    let initialSize = CGSize(width: 44, height: 63)
    var sceneSize = CGSize(width: 812, height: 375)
    let groundHeight:CGFloat = 43
    
    let alien_images = ["alienBlue_walk1","alienBlue_walk2","alienBlue_hit"]
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        
        self.life = 3
        
        images = alien_images
        
        self.xScale = -1
        
        createSwitchAnimation()
        createMoveAnimation()
        createDieAnimation()
    
        run(switchAndMove)
         
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func createMoveAnimation(){
        
        var actions = [SKAction]()
        
        let rightTop = CGPoint(x: sceneSize.width/2 - 50, y: sceneSize.height/2 - 30)
        let rightMiddle = CGPoint(x: sceneSize.width/2 - 50, y: 0)
        let rightGround = CGPoint(x: sceneSize.width/2 - 50, y: -sceneSize.height/2 + groundHeight)
                
        let moveRightTop = SKAction.move(to: rightTop, duration: 0.5)
        actions.append(moveRightTop)
        
        let moveRightMiddle = SKAction.move(to: rightMiddle, duration: 0.5)
        actions.append(moveRightMiddle)
        
        let moveRightGround = SKAction.move(to: rightGround, duration: 0.5)
        actions.append(moveRightGround)
        
        let randomMove = SKAction.run {
            let random:Int = Int.random(in: 0..<actions.count)
            self.run(actions[random])
        }
        
        let shot = SKAction.run {
            self.shotFireball()
        }
        
        let buffer = SKAction.wait(forDuration: 0.5)
        
        let shotFireball = SKAction.sequence([buffer,shot,buffer])
        
        movingAnimation = SKAction.repeatForever(SKAction.sequence([
            randomMove,shotFireball
        ]))
        
        switchAndMove = SKAction.group([switchAnimation,movingAnimation])
    }
    
    override func die() {
        self.removeAllActions()
        self.run(dieAnimation)
        
        if let gameScene = self.scene as? GameScene{
            gameScene.gameClear()
            SaveData().save(key: "stage3", value: true)
        }
    }
    
    override func takeDamage(damage: Int) {
        
        life -= damage
         
        if life <= 0{
            die()
        }
    }
    
}
