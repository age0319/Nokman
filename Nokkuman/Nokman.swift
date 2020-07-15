//
//  Nokkuman.swift
//  Nokkuman
//
//  Created by haru on 2020/07/08.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import SpriteKit

class Nokman :SKSpriteNode{
    // キャラクターのサイズを指定します。
    let initialSize = CGSize(width: 96, height: 96)
    // キャラクターの位置を指定します。
    let initialPosition = CGPoint(x: 0, y: 100)
    // テキスチャーアトラスを指定する
    var textureAtlas = SKTextureAtlas(named:"Nokkuman")
  
    // アニメーションを指定する
    var runAnimation = SKAction()
    var idleAnimation = SKAction()
    var jumpAnimation = SKAction()
    var fireAnimation = SKAction()
    
    var rightMoving = false
    var leftMoving = false
    var jumping = false
    var firing = false
    
    var backward = false
    
    init() {
        super.init(texture: SKTexture(imageNamed: "2_entity_000_IDLE_000"), color: .clear, size: initialSize)
  
        self.position = initialPosition
                
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size:self.size)
        
        self.physicsBody?.mass = 30
        
        self.physicsBody?.allowsRotation = false
        
        // アニメーションの作成
        createAnimations()
        // アイドル状態の開始
        self.startIdleAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // テキスチャからアニメーションを作成する
    func createAnimations() {
        
        // 何もしていない時のアニメーションを追加するよ
        let idleFrames:[SKTexture] =
            [
                textureAtlas.textureNamed("2_entity_000_IDLE_000"),
                textureAtlas.textureNamed("2_entity_000_IDLE_001"),
                textureAtlas.textureNamed("2_entity_000_IDLE_002"),
                textureAtlas.textureNamed("2_entity_000_IDLE_003"),
                textureAtlas.textureNamed("2_entity_000_IDLE_004"),
                textureAtlas.textureNamed("2_entity_000_IDLE_005"),
                textureAtlas.textureNamed("2_entity_000_IDLE_006"),
            ]
        
        // 1フレームあたりの表示時間は0.14秒
        let idleAction = SKAction.animate(with: idleFrames, timePerFrame: 0.14)
        idleAnimation = SKAction.repeatForever(idleAction)

        // 走っているアニメーションを追加するよ
        let runFrames:[SKTexture] =
            [
                textureAtlas.textureNamed("2_entity_000_RUN_000"),
                textureAtlas.textureNamed("2_entity_000_RUN_001"),
                textureAtlas.textureNamed("2_entity_000_RUN_002"),
                textureAtlas.textureNamed("2_entity_000_RUN_003"),
                textureAtlas.textureNamed("2_entity_000_RUN_004"),
                textureAtlas.textureNamed("2_entity_000_RUN_005"),
                textureAtlas.textureNamed("2_entity_000_RUN_006"),
            ]
        
        // 1フレームあたりの表示時間は0.05秒
        let runAction = SKAction.animate(with: runFrames,timePerFrame: 0.05)
        
        runAnimation = SKAction.repeatForever(runAction)
        
        // ジャンプのアニメーションを追加するよ
        let jumpFrames:[SKTexture] =
            [
                textureAtlas.textureNamed("2_entity_000_JUMP_000"),
                textureAtlas.textureNamed("2_entity_000_JUMP_001"),
                textureAtlas.textureNamed("2_entity_000_JUMP_002"),
                textureAtlas.textureNamed("2_entity_000_JUMP_003"),
                textureAtlas.textureNamed("2_entity_000_JUMP_004"),
                textureAtlas.textureNamed("2_entity_000_JUMP_005"),
                textureAtlas.textureNamed("2_entity_000_JUMP_006"),
            ]
        
        // 1フレームあたりの表示時間は0.08秒
        jumpAnimation = SKAction.animate(with: jumpFrames,timePerFrame: 0.08)
        
        // 発泡のアニメーションを追加するよ
        let fireFrames:[SKTexture] =
            [
                textureAtlas.textureNamed("2_entity_000_ATTACK_005"),
                textureAtlas.textureNamed("2_entity_000_ATTACK_006"),
            ]
        
        fireAnimation = SKAction.animate(with: fireFrames,timePerFrame: 0.05)
        
    }
    
    // キャラクターを走らせる
    func startRunAnimation(){
        if self.backward {
            self.xScale = -1
        } else {
            self.xScale = 1
        }
        self.run(runAnimation, withKey: "runAnimation")
    }
    
    // キャラクターをアイドル状態にする
    func startIdleAnimation(){
        self.run(idleAnimation, withKey: "idleAnimation")
    }
    
    // ジャンプアニメーションを開始する
    func startJumpAnimation(){
        self.run(jumpAnimation)
    }
    
    func startFireAnimation(){
        self.run(fireAnimation)
    }
    
    func update(){
        if self.rightMoving {
            self.physicsBody?.velocity.dx = 150
        } else if leftMoving {
            self.physicsBody?.velocity.dx = -150
        }
    }
}
