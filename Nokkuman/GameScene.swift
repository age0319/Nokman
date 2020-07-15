//
//  GameScene.swift
//  Nokkuman
//
//  Created by haru on 2020/07/08.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import SpriteKit
import GameplayKit

enum ZPositions: Int {
    case background
    case foreground
    case player
    case otherNodes
}

class GameScene: SKScene {
    
    let nokman = Nokman()
    let ground = Ground()
    let bg = Background()
    let cam = SKCameraNode()
        
    override func didMove(to view: SKView) {

        self.anchorPoint = .zero
        
        // 背景画像をセット
        bg.createBackgound(frameSize: self.size,num: 3)
        bg.zPosition = CGFloat(ZPositions.background.rawValue)
        addChild(bg)
        
        // 地面をセット
        ground.createGround(frameSize: self.size, num: 3)
        ground.zPosition = CGFloat(ZPositions.foreground.rawValue)
        self.addChild(ground)

        // プレイヤーをセット
        nokman.zPosition = CGFloat(ZPositions.player.rawValue)
        self.addChild(nokman)
        setupButtons()

        //カメラをセット
        self.camera = cam
        self.addChild(cam)
        
    }
    
    override func didSimulatePhysics() {
        //横スクロールゲームのため、高さは固定でx座標だけ動けば良い。
        self.camera?.position = CGPoint(x: self.nokman.position.x, y:0)
    }
    
    func setupButtons(){
        // カメラに追随して動くようにボタンはカメラの子として設置する。
        // カメラ(SKCameraNode)の開始座標はフレームの中心。
        // 開始座標を左下にするためにフレームの中心座標を引く。
        
        let halfPoint = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        
        // 左ボタンをセット
        let leftMove = SKSpriteNode(imageNamed: "flatDark23")
        
        leftMove.size = CGSize(width: 40, height: 40)
        
        leftMove.position = CGPoint(x:70 - halfPoint.x, y:35 - halfPoint.y)
        
        leftMove.name = "Left"
        
        leftMove.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        cam.addChild(leftMove)
        
        //　右ボタンをセット
        let rightMove = SKSpriteNode(imageNamed: "flatDark24")
        
        rightMove.size = CGSize(width: 40, height: 40)
        
        rightMove.position = CGPoint(x:120 - halfPoint.x, y:35 - halfPoint.y)
        
        rightMove.name = "Right"
        
        rightMove.zPosition = CGFloat(ZPositions.otherNodes.rawValue)

        cam.addChild(rightMove)
        
        // ジャンプボタンをセット
        let jump = SKSpriteNode(imageNamed: "flatDark25")
        
        jump.size = CGSize(width: 40, height: 40)
               
        jump.position = CGPoint(x:750 - halfPoint.x, y:35 - halfPoint.y)
        
        jump.zPosition = CGFloat(ZPositions.otherNodes.rawValue)

        jump.name = "Jump"
        
        cam.addChild(jump)
        
        // ジャンプボタンをセット
        let fire = SKSpriteNode(imageNamed: "flatDark35")
        
        fire.size = CGSize(width: 40, height: 40)
        
        fire.position = CGPoint(x:800 - halfPoint.x, y:35 - halfPoint.y)
        
        fire.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        fire.name = "Fire"
        
        cam.addChild(fire)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチしたボタンによって処理を分ける
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if (node.name == "Left") {
                startLeftMove()
            } else if (node.name == "Right") {
                startRightMove()
            } else if ( node.name == "Jump") {
                self.nokman.jumping = true
            } else if ( node.name == "Fire"){
                self.nokman.firing = true
            }
        }
    }
    
    func startRightMove(){
        self.nokman.backward = false
        self.nokman.rightMoving = true
        self.nokman.startRunAnimation()
    }
    
    func stopRightMove(){
        self.nokman.rightMoving = false
        self.nokman.startIdleAnimation()
    }
    
    func startLeftMove(){
        self.nokman.backward = true
        self.nokman.leftMoving = true
        self.nokman.startRunAnimation()
    }
    
    func stopLeftMove(){
        self.nokman.leftMoving = false
        self.nokman.startIdleAnimation()
    }
    
    func startJump(){
        self.nokman.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15000))
        self.nokman.startJumpAnimation()
    }
    
    func startFire(){
        self.nokman.startFireAnimation()

        let shot = Shot(pos: self.nokman.position, bw:self.nokman.backward)
        self.addChild(shot)
        shot.fire()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name == "Left" {
                stopLeftMove()
            } else if node.name == "Right" {
                stopRightMove()
            } else if node.name == "Jump" {
                self.nokman.jumping = false
            } else if node.name == "Fire" {
                self.nokman.firing = false
            }
        }
    }
    
    var jumpTime:Double = 0
    var jumpInterval:Double = 0.8
    
    var fireTime:Double = 0
    var fireInterval:Double = 0.1
    
    override func update(_ currentTime: TimeInterval) {
        
        nokman.update()
        
        //　ジャンプフラグが立っていなければ終了
        if self.nokman.jumping {
            // インターバルを空けないとジャンプできないようにする
            if jumpTime == 0 || currentTime - jumpTime > jumpInterval {
                startJump()
                jumpTime = currentTime
            }
        }
        
        if self.nokman.firing {
            // インターバルを空けないと発砲できないようにする
            if fireTime == 0 || currentTime - fireTime > fireInterval {
                startFire()
                fireTime = currentTime
            }
        }
    }
}

