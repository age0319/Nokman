//
//  Nokkuman.swift
//  Nokkuman
//
//  Created by haru on 2020/07/08.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import SpriteKit

class Nokkuman :SKSpriteNode{
    // キャラクターのサイズを指定します。
    let initialSize = CGSize(width: 64, height: 64)
    // キャラクターの位置を指定します。
    let initialPosition = CGPoint(x: 200, y: 100)
    // テキスチャーアトラスを指定する
    var textureAtlas = SKTextureAtlas(named:"Nokkuman")
  
    // アニメーションを指定する
    var runAnimation = SKAction()
    var idleAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        self.position = initialPosition
        //主人公に物理エンジンを与えて速度を与える
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        self.physicsBody?.mass = 30
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
            [textureAtlas.textureNamed("2_entity_000_IDLE_000"),
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
            [textureAtlas.textureNamed("2_entity_000_RUN_000"),
             textureAtlas.textureNamed("2_entity_000_RUN_001"),
             textureAtlas.textureNamed("2_entity_000_RUN_002"),
             textureAtlas.textureNamed("2_entity_000_RUN_003"),
             textureAtlas.textureNamed("2_entity_000_RUN_004"),
             textureAtlas.textureNamed("2_entity_000_RUN_005"),
             textureAtlas.textureNamed("2_entity_000_RUN_006"),
            ]
        
        // 1フレームあたりの表示時間は0.14秒
        let runAction = SKAction.animate(with: runFrames,timePerFrame: 0.05)
        
        runAnimation = SKAction.repeatForever(runAction)
        
    }
    
    // キャラクターを走らせる
    func startRunAnimation(){
        self.run(runAnimation, withKey: "runAnimation")
    }
    
    // キャラクタの向きを変える
    func changeDirection(forward:Bool){
        if forward {
            let flipTexturePositive = SKAction.scaleX(to: 1, duration: 0)
            self.run(flipTexturePositive)
        } else {
            let flipTextureNegative = SKAction.scaleX(to: -1, duration: 0)
            self.run(flipTextureNegative)
        }
    }
    
    // キャラクターをアイドル状態にする
    func startIdleAnimation(){
//        self.removeAction(forKey: "runAnimation")
        self.run(idleAnimation, withKey: "idleAnimation")
    }
    
}
