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
    
    let nokkuman = Nokkuman()
    let ground = Ground()
    let cam = SKCameraNode()
        
    override func didMove(to view: SKView) {

        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        nokkuman.zPosition = CGFloat(ZPositions.player.rawValue)
        self.addChild(nokkuman)
        
        // フレームの3倍の大きさの地面を作る
        ground.size = CGSize(width: self.size.width * 3, height: 0)
        // 地面のx開始点は-1フレーム分の場所から。
        ground.position = CGPoint(x: -1 * self.size.width, y: 0)
        ground.createGround(frameSize: self.size)
        ground.zPosition = CGFloat(ZPositions.background.rawValue)
        self.addChild(ground)
        
        setupButtons()
 
        self.camera = cam
        self.addChild(cam)
        
    }
    
    override func didSimulatePhysics() {
        //カメラのポジションはプレイヤーのx座標とフレームの高さの半分。
        //横スクロールゲームのため、高さは固定でx座標だけ動けば良い。
        self.camera?.position = CGPoint(x: self.nokkuman.position.x,
        y: self.size.height / 2)
    }
    
    func setupButtons(){
        // カメラに追随して動くようにボタンはカメラの子として設置する。
        // カメラ(SKCameraNode)の開始座標はフレームの中心。
        // 開始座標を左下にするためにフレームの中心座標を引き算する
        let halfPoint = CGPoint(x: self.size.width/2, y: self.size.height/2)

        // 四角形の大きさを決める
        let Rect = CGRect(x: 0, y: 0, width: 40, height: 40)
        let circle = UIBezierPath(roundedRect: Rect, cornerRadius: 5)

        let leftMove = SKShapeNode(path: circle.cgPath, centered: true)
        
        leftMove.position = CGPoint(x:70 - halfPoint.x, y:35 - halfPoint.y)
        
        leftMove.name = "Left"
        
        leftMove.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        cam.addChild(leftMove)
        
        let rightMove = SKShapeNode(path: circle.cgPath, centered: true)
        
        rightMove.position = CGPoint(x:120 - halfPoint.x, y:35 - halfPoint.y)
        
        rightMove.name = "Right"
        
        rightMove.zPosition = CGFloat(ZPositions.otherNodes.rawValue)

        cam.addChild(rightMove)
        
        let jump = SKShapeNode(path: circle.cgPath, centered: true)
               
        jump.position = CGPoint(x:700 - halfPoint.x, y:35 - halfPoint.y)
        
        jump.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        jump.name = "Jump"
        
        cam.addChild(jump)
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
                self.nokkuman.jump = true
            }
        }
    }
    
    func startRightMove(){
        self.nokkuman.rightMove = true
        self.nokkuman.lookForward()
        self.nokkuman.startRunAnimation()
    }
    
    func stopRightMove(){
        self.nokkuman.rightMove = false
        self.nokkuman.startIdleAnimation()
    }
    
    func startLeftMove(){
        self.nokkuman.leftMove = true
        self.nokkuman.lookBackward()
        self.nokkuman.startRunAnimation()
    }
    
    func stopLeftMove(){
        self.nokkuman.leftMove = false
        self.nokkuman.startIdleAnimation()
    }
    
    func startJump(){
        self.nokkuman.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15000))
        self.nokkuman.startJumpAnimation()
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
                self.nokkuman.jump = false
            }
        }
    }
    
    var updateTime:Double = 0
    // ジャンプ時間のインターバルを設定する
    var jumpInterval:Double = 0.8
    
    override func update(_ currentTime: TimeInterval) {
        
        nokkuman.update()
        
        //　ジャンプフラグが立っていなければ終了
        guard self.nokkuman.jump else {
            return
        }
                
        // インターバルを空けないと再度ジャンプできないようにする
        if updateTime == 0 || currentTime - updateTime > jumpInterval {
            startJump()
            updateTime = currentTime
        }
    }
}
