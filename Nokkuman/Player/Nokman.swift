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
    let initialPosition = CGPoint(x: -320, y: -80)
    // テキスチャーアトラスを指定する
    var textureAtlas = SKTextureAtlas(named:"Nokkuman")
  
    let runSpeed:CGFloat = 150
    let damage = CGVector(dx: -5000, dy: 5000)
    
    // アニメーションを指定する
    var runAnimation = SKAction()
    var idleAnimation = SKAction()
    var jumpAnimation = SKAction()
    var fireAnimation = SKAction()
    var hurtAnimation = SKAction()
    
    var rightMoving = false
    var leftMoving = false
    var jumping = false
    var firing = false
    var damaging = false
    
    var backward = false
    
    init() {
        super.init(texture: SKTexture(imageNamed: "2_entity_000_IDLE_000"), color: .clear, size: initialSize)
  
        self.position = initialPosition
                
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size:self.size)
        
        self.physicsBody?.mass = 30
        
        self.physicsBody?.allowsRotation = false
        
        self.zPosition = CGFloat(ZPositions.player.rawValue)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.nokman.rawValue
        
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue |
            PhysicsCategory.ground.rawValue |
            PhysicsCategory.box.rawValue
                
        // アニメーションの作成
        createAnimations()
        
        // アイドル状態の開始
        self.Idle()
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
        
        // 何もしていない時のアニメーションを追加するよ
        let hurtFrames:[SKTexture] =
            [
                textureAtlas.textureNamed("2_entity_000_HURT_000"),
                textureAtlas.textureNamed("2_entity_000_HURT_001"),
                textureAtlas.textureNamed("2_entity_000_HURT_002"),
                textureAtlas.textureNamed("2_entity_000_HURT_003"),
                textureAtlas.textureNamed("2_entity_000_HURT_004"),
                textureAtlas.textureNamed("2_entity_000_HURT_005"),
                textureAtlas.textureNamed("2_entity_000_HURT_006"),
        ]
        
        // 1フレームあたりの表示時間は0.14秒
        hurtAnimation = SKAction.animate(with: hurtFrames, timePerFrame: 0.05)
        
    }
    
    func Hurt(){
        
        if damaging { return }
            
        damaging = true
        
        self.run(hurtAnimation)
        
        self.physicsBody?.applyImpulse(damage)
        
        let damegeStart = SKAction.run{
            //敵をすり抜ける。地面とだけ衝突する。
            self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
            self.alpha = 0.3
        }
        let wait = SKAction.wait(forDuration: 3)
        let damegeEnd = SKAction.run {
            //元に戻す。すべての物体の衝突する。
            self.physicsBody?.collisionBitMask = 0xFFFFFFFF
            self.alpha = 1
            self.damaging = false
        }
        
        self.run(SKAction.sequence([
            damegeStart,
            wait,
            damegeEnd]))
            
            
    }
    
    // キャラクターを走らせる
    func Run(bw:Bool){
        self.backward = bw
        if self.backward {
            self.xScale = -1
            self.leftMoving = true
        } else {
            self.xScale = 1
            self.rightMoving = true
        }
        self.run(runAnimation, withKey: "runAnimation")
    }
    
    // キャラクターをアイドル状態にする
    func Idle(){
        self.run(idleAnimation, withKey: "idleAnimation")
    }
    
    // ジャンプアニメーションを開始する
    func Jump(){
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15000))
        self.run(jumpAnimation)
    }
    
    func Fire(){
        self.run(fireAnimation)
    }
    
    func update(_ currentTime: TimeInterval){
        
        if self.rightMoving {
            self.physicsBody?.velocity.dx = runSpeed
        } else if leftMoving {
            self.physicsBody?.velocity.dx = -runSpeed
        }
        
    }
    
}
