//
//  Enemy.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/22.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit


// 基本的な敵の設定を作る。敵ごとの動きは継承先にて実装。
class Enemy: SKSpriteNode {
    
    var textureAtlas = SKTextureAtlas(named:"Enemies")
    var switchAnimation = SKAction()
    var movingAnimation = SKAction()
    var dieAnimation = SKAction()
    var switchAndMove = SKAction()
    
    let runSpeed:CGFloat = 100
    
    var life = 5
    
    var images = [String]()
    
    // SKSpriteNodeを継承して敵としての初期設定をする
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
      
        super.init(texture: texture, color: .clear, size: size)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        
        self.physicsBody?.mass = 20
        
        self.physicsBody?.allowsRotation = false
        
        self.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        
        //火の玉は当たらないようにする
        self.physicsBody?.collisionBitMask = ~PhysicsCategory.fireball.rawValue
    }
    
    func createSwitchAnimation() {
        let Frames:[SKTexture] =
            [
                textureAtlas.textureNamed(images[0]),
                textureAtlas.textureNamed(images[1])
        ]
        
        let Action = SKAction.animate(with: Frames, timePerFrame: 0.14)
        
        //２枚のテキスチャを動かして動きをつける
        switchAnimation = SKAction.repeatForever(Action)
    }
    
    func createMoveAnimation(){
        // Please implement
        let flipLeft = SKAction.scaleX(to: 1, duration: 0.05)
        let moveLeft = SKAction.move(by: CGVector(dx: -100, dy: 0), duration: 2)
        let flipRight = SKAction.scaleX(to: -1, duration: 0.05)
        let moveRight = SKAction.move(by: CGVector(dx: 100, dy: 0), duration: 2)
        
        // 左、右、左と永遠に移動を繰り返す
        movingAnimation = SKAction.repeatForever(SKAction.sequence([flipLeft,moveLeft,flipRight,moveRight]))
        
        // 左右に行き来するアニメーション。カエルとフライで利用を想定。
        switchAndMove = SKAction.group([switchAnimation,movingAnimation])
    }
    
    func createDieAnimation(){
        let startDie = SKAction.run {
            self.texture = self.textureAtlas.textureNamed(self.images[2])
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            // 死んだら落下するようにする
            self.physicsBody?.affectedByGravity = true
            
            // 判定を無効に
            self.physicsBody?.collisionBitMask = 0
            self.physicsBody?.categoryBitMask = 0
        }
        
        let fadeout = SKAction.fadeOut(withDuration: 1)
        
        let endDie = SKAction.removeFromParent()
        
        dieAnimation = SKAction.sequence([startDie,fadeout,endDie])

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func die(){
        self.removeAllActions()
        self.run(dieAnimation)
    }
    
    func takeDamage(damage:Int){
        
        life -= damage
        
        if life <= 0{
            die()
        }
    }
}
