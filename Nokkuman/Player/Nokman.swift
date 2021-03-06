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
    let initialPosition = CGPoint(x: -380, y: 0)
    // テキスチャーアトラスを指定する
    var textureAtlas = SKTextureAtlas(named:"Nokkuman")
  
    let runSpeed:CGFloat = 150
    let damageImpulse = CGVector(dx: -5000, dy: 5000)
    
    var maxLife = 5
    var life = 5
    
    // アニメーションを指定する
    var runAnimation = SKAction()
    var idleAnimation = SKAction()
    var jumpAnimation = SKAction()
    var fireAnimation = SKAction()
    var hurtAnimation = SKAction()
    var dieAnimation = SKAction()
    var chargeAnimation = SKAction()
    
    var rightMoving = false
    var leftMoving = false
    var die = false
    
    var backward = false
    
    init() {
        
        super.init(texture: nil, color: .clear, size: initialSize)
  
        self.position = initialPosition
        
        // キャラの位置が画像の左下に偏っているため中心地をずらす
        self.anchorPoint = CGPoint(x: 0.4, y: 0.4)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        
        self.physicsBody?.mass = 30
        
        self.physicsBody?.allowsRotation = false
        
        self.zPosition = CGFloat(ZPositions.player.rawValue)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.nokman.rawValue
        
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue |
            PhysicsCategory.ground.rawValue |
            PhysicsCategory.box.rawValue |
            PhysicsCategory.spike.rawValue |
            PhysicsCategory.exit.rawValue
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
        

        jumpAnimation = SKAction.animate(with: jumpFrames,timePerFrame: 0.05)
        
        // 発泡のアニメーションを追加するよ
        let fireFrames:[SKTexture] =
            [
                textureAtlas.textureNamed("2_entity_000_ATTACK_005"),
                textureAtlas.textureNamed("2_entity_000_ATTACK_006"),
            ]
        
        fireAnimation = SKAction.animate(with: fireFrames,timePerFrame: 0.05)
        
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
        
        hurtAnimation = SKAction.animate(with: hurtFrames, timePerFrame: 0.05)

        let dieFrames:[SKTexture] =
            [
                textureAtlas.textureNamed("2_entity_000_DIE_000"),
                textureAtlas.textureNamed("2_entity_000_DIE_001"),
                textureAtlas.textureNamed("2_entity_000_DIE_002"),
                textureAtlas.textureNamed("2_entity_000_DIE_003"),
                textureAtlas.textureNamed("2_entity_000_DIE_004"),
                textureAtlas.textureNamed("2_entity_000_DIE_005"),
                textureAtlas.textureNamed("2_entity_000_DIE_006"),
        ]
        
        dieAnimation = SKAction.animate(with: dieFrames, timePerFrame: 0.05)
        
        // チャージが始まるまで少しバッファを持たせることで通常弾時に青くならない。
        let wait = SKAction.wait(forDuration: 0.2)
        
        let colarChange = SKAction.sequence([
            SKAction.colorize(with: .blue, colorBlendFactor: 0.5, duration: 0.2),
            SKAction.colorize(with: .blue, colorBlendFactor: 0.0, duration: 0.2)
            ])
        
        let charge = SKAction.repeatForever(colarChange)
        
        chargeAnimation = SKAction.sequence([wait,charge])
    }
    
    func Die(){
        die = true
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.physicsBody?.categoryBitMask = 0
        
        removeAllActions()
        run(dieAnimation)
        
        if let gameScene = self.parent as? GameScene{
            gameScene.gameOver()
        }
    }
    
    func Cure(heart:Int){
        if life == maxLife { return }
        life += heart
        if let gameScene = self.parent as? GameScene{
            gameScene.hud.updateHeartDisplay(life: self.life)
        }
    }
    
    func Hurt(damage:Int){
    
        life -= damage
        
        if let gameScene = self.parent as? GameScene{
            gameScene.hud.updateHeartDisplay(life: self.life)
        }
        
        if life <= 0{
            Die()
            
        } else {
        
            self.run(hurtAnimation)
            
            self.physicsBody?.applyImpulse(damageImpulse)
            
            let damageStart = SKAction.run{
                //接触判定を無効にする。
                self.physicsBody?.categoryBitMask = 0
                // グラウンドのみぶつかるようにする。敵や火の粉は貫通する。
                self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue |
                    PhysicsCategory.spike.rawValue
                // 透明にする
                self.alpha = 0.3
            }
            let wait = SKAction.wait(forDuration: 3)
            let damageEnd = SKAction.run {
                //接触判定を元に戻す
                self.physicsBody?.categoryBitMask = PhysicsCategory.nokman.rawValue
                //すべてにぶつかるようにする。
                self.physicsBody?.collisionBitMask = 0xFFFFFFFF
                self.alpha = 1
            }
            
            self.run(SKAction.sequence([
                damageStart,
                wait,
                damageEnd]))
        }
            
    }
    
    // キャラクターを走らせる
    func Run(bw:Bool){
        
        if die { return }
        
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
    
    func Stop(bw:Bool){
        
        if bw {
            self.leftMoving = false
        }else{
            self.rightMoving = false
        }
        Idle()
    }
    
    // キャラクターをアイドル状態にする
    func Idle(){
        
        if die { return }
        
        self.run(idleAnimation, withKey: "idleAnimation")
    }
    
    // ジャンプアニメーションを開始する
    func Jump(){
        
        if die { return }
        
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15000))
        self.run(jumpAnimation)

    }
    
    func Fire(charged:Bool){
        
        if die { return }
                
        self.run(fireAnimation)
        
        let shot = Shot(pos: self.position, bw:self.backward, charged: charged)
        self.parent!.addChild(shot)
        shot.fire()
    }
    
    func Charge(on:Bool){
        if on {
            self.run(chargeAnimation,withKey: "charge")
        }else{
             self.removeAction(forKey: "charge")
            self.colorBlendFactor = 0.0
        }
    }
            
    func update(){
        
        if self.rightMoving {
            self.physicsBody?.velocity.dx = runSpeed
        } else if leftMoving {
            self.physicsBody?.velocity.dx = -runSpeed
        }
        
    }
    
}
