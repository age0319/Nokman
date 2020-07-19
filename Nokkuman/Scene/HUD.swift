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
    var maxLife = Int()
    
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
        let leftMove = SKSpriteNode(imageNamed: "flatDark23")
        leftMove.size = buttonSize
        leftMove.position = CGPoint(x: -cameraOrigin.x + 60, y: -cameraOrigin.y + 30)
        leftMove.name = "Left"
        leftMove.zPosition = CGFloat(ZPositions.button.rawValue)
        cam.addChild(leftMove)
        
        //　右ボタンをセット
        let rightMove = SKSpriteNode(imageNamed: "flatDark24")
        rightMove.size = buttonSize
        rightMove.position = CGPoint(x: -cameraOrigin.x + 150, y: -cameraOrigin.y + 30)
        rightMove.name = "Right"
        rightMove.zPosition = CGFloat(ZPositions.button.rawValue)
        cam.addChild(rightMove)
        
        // ジャンプボタンをセット
        let jump = SKSpriteNode(imageNamed: "flatDark25")
        jump.size = buttonSize
        jump.position = CGPoint(x: cameraOrigin.x - 150, y: -cameraOrigin.y + 30)
        jump.zPosition = CGFloat(ZPositions.button.rawValue)
        jump.name = "Jump"
        cam.addChild(jump)
        
        // ジャンプボタンをセット
        let fire = SKSpriteNode(imageNamed: "flatDark35")
        fire.size = buttonSize
        fire.position = CGPoint(x: cameraOrigin.x - 60, y: -cameraOrigin.y + 30)
        fire.zPosition = CGFloat(ZPositions.button.rawValue)
        fire.name = "Fire"
        
        cam.addChild(fire)
        
    }
    
    func setupHeartDisplay(maxLife:Int){
        self.maxLife = maxLife
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
