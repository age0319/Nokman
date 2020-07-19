//
//  HUD.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/19.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class HUD {

    var cam = SKCameraNode()
    var scene  = SKScene()
    var cameraOrigin = CGPoint()
    var heartNodes = [Heart]()
    var leftMoveButton = SKSpriteNode()
    var rightMoveButton = SKSpriteNode()
    var jumpButton = SKSpriteNode()
    var fireButton = SKSpriteNode()
    var restartButton = SKSpriteNode()
    
    init() {
    }
    
    func setup(cam:SKCameraNode,scene:SKScene) {
        self.cam = cam
        self.scene = scene
        self.cameraOrigin = CGPoint(x: self.scene.size.width/2, y: self.scene.size.height/2)
    }
    
    func setupButton(){
        // カメラに追随して動くようにボタンはカメラの子として設置する。
        // カメラ(SKCameraNode)の開始座標はフレームの中心。
        // 開始座標を左下にするためにフレームの中心座標を引く。
        
        let buttonSize = CGSize(width: 60, height: 60)
                
        // 左ボタンをセット
        leftMoveButton = SKSpriteNode(imageNamed: "flatDark23")
        leftMoveButton.size = buttonSize
        leftMoveButton.position = CGPoint(x: -cameraOrigin.x + 60, y: -cameraOrigin.y + 30)
        leftMoveButton.name = "Left"
        leftMoveButton.zPosition = CGFloat(ZPositions.button.rawValue)
        cam.addChild(leftMoveButton)
        
        //　右ボタンをセット
        rightMoveButton = SKSpriteNode(imageNamed: "flatDark24")
        rightMoveButton.size = buttonSize
        rightMoveButton.position = CGPoint(x: -cameraOrigin.x + 150, y: -cameraOrigin.y + 30)
        rightMoveButton.name = "Right"
        rightMoveButton.zPosition = CGFloat(ZPositions.button.rawValue)
        cam.addChild(rightMoveButton)
        
        // ジャンプボタンをセット
        jumpButton = SKSpriteNode(imageNamed: "flatDark25")
        jumpButton.size = buttonSize
        jumpButton.position = CGPoint(x: cameraOrigin.x - 150, y: -cameraOrigin.y + 30)
        jumpButton.zPosition = CGFloat(ZPositions.button.rawValue)
        jumpButton.name = "Jump"
        cam.addChild(jumpButton)
        
        // 発射ボタンをセット
        fireButton = SKSpriteNode(imageNamed: "flatDark35")
        fireButton.size = buttonSize
        fireButton.position = CGPoint(x: cameraOrigin.x - 60, y: -cameraOrigin.y + 30)
        fireButton.zPosition = CGFloat(ZPositions.button.rawValue)
        fireButton.name = "Fire"
        
        cam.addChild(fireButton)
        
        restartButton = SKSpriteNode(imageNamed: "flatDark15")
        restartButton.size = CGSize(width: 50, height: 50)
        restartButton.position = CGPoint(x: 0, y: 0)
        restartButton.zPosition = CGFloat(ZPositions.button.rawValue)
        restartButton.name = "Restart"
        
    }
    
    func showRestartButton(){
        let gameoverText = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        gameoverText.text = "GameOver"
        gameoverText.position = CGPoint(x: 0, y: 80)
        gameoverText.fontSize = 60
        cam.addChild(gameoverText)
        cam.addChild(restartButton)
    }
    
    func setupHeartDisplay(maxLife:Int){
        for i in 0...maxLife-1{
            let heart = Heart(imageNamed:"hudHeart_full")
            heart.position = CGPoint(x: -cameraOrigin.x + CGFloat(30*(i+1)), y: cameraOrigin.y - 30)
            heart.id = i
            cam.addChild(heart)
            heartNodes.append(heart)
        }
    }
    
    func updateHeartDisplay(life:Int){
        
        for index in 0 ..< heartNodes.count{
            if index <= life-1{
                heartNodes[index].Fill()
            }else{
                heartNodes[index].Empty()
            }
        }
    }
}
