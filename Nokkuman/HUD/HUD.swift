//
//  HUD.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/19.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class HUD:SKSpriteNode {

    var cameraOrigin = CGPoint()
    var heartNodes = [Heart]()
    var leftMoveButton = SKSpriteNode()
    var rightMoveButton = SKSpriteNode()
    var upButton = SKSpriteNode()
    var AButton = SKSpriteNode()
    var restartButton = SKSpriteNode()
    var backButton = SKSpriteNode()
    
    func setupButton(){
        // カメラに追随して動くようにボタンはカメラの子として設置する。
        // カメラ(SKCameraNode)の開始座標はフレームの中心。
        // 開始座標を左下にするためにフレームの中心座標を引く。
        
        cameraOrigin = CGPoint(x: self.scene!.size.width/2, y: self.scene!.size.height/2)
        
        let buttonSize = CGSize(width: 60, height: 60)
                
        // 左ボタンをセット
        leftMoveButton = SKSpriteNode(imageNamed: "flatDark23")
        leftMoveButton.size = buttonSize
        leftMoveButton.position = CGPoint(x: -cameraOrigin.x + 60, y: -cameraOrigin.y + 30)
        leftMoveButton.name = "Left"
        leftMoveButton.zPosition = CGFloat(ZPositions.button.rawValue)
        self.parent!.addChild(leftMoveButton)
        
        //　右ボタンをセット
        rightMoveButton = SKSpriteNode(imageNamed: "flatDark24")
        rightMoveButton.size = buttonSize
        rightMoveButton.position = CGPoint(x: -cameraOrigin.x + 150, y: -cameraOrigin.y + 30)
        rightMoveButton.name = "Right"
        rightMoveButton.zPosition = CGFloat(ZPositions.button.rawValue)
        self.parent!.addChild(rightMoveButton)
        
        // ジャンプボタンをセット
        upButton = SKSpriteNode(imageNamed: "flatDark25")
        upButton.size = buttonSize
        upButton.position = CGPoint(x: cameraOrigin.x - 150, y: -cameraOrigin.y + 30)
        upButton.zPosition = CGFloat(ZPositions.button.rawValue)
        upButton.name = "Jump"
        self.parent!.addChild(upButton)
        
        // 発射ボタンをセット
        AButton = SKSpriteNode(imageNamed: "flatDark35")
        AButton.size = buttonSize
        AButton.position = CGPoint(x: cameraOrigin.x - 60, y: -cameraOrigin.y + 30)
        AButton.zPosition = CGFloat(ZPositions.button.rawValue)
        AButton.name = "Fire"
        self.parent!.addChild(AButton)
        
        restartButton = SKSpriteNode(imageNamed: "flatDark15")
        restartButton.size = CGSize(width: 50, height: 50)
        restartButton.position = CGPoint(x: -50, y: 0)
        restartButton.zPosition = CGFloat(ZPositions.button.rawValue)
        restartButton.name = "Restart"
        
        backButton = SKSpriteNode(imageNamed: "flatDark20")
        backButton.size = CGSize(width: 50, height: 50)
        backButton.position = CGPoint(x: 50, y: 0)
        backButton.zPosition = CGFloat(ZPositions.button.rawValue)
        backButton.name = "Back"
                
    }
    
    func onLeftButton(on:Bool){
        if on {
            leftMoveButton.texture = SKTexture(imageNamed: "flatLight22")
        }else{
            leftMoveButton.texture = SKTexture(imageNamed: "flatDark23")
        }
    }
    
    func onRightButton(on:Bool){
        if on {
            rightMoveButton.texture = SKTexture(imageNamed: "flatLight23")
        }else{
            rightMoveButton.texture = SKTexture(imageNamed: "flatDark24")
        }
    }
    
    func onUpButton(on:Bool){
        if on {
            upButton.texture = SKTexture(imageNamed: "flatLight24")
        }else{
            upButton.texture = SKTexture(imageNamed: "flatDark25")
        }
    }
    
    func onAButton(on:Bool){
        if on {
            AButton.texture = SKTexture(imageNamed: "flatLight34")
        }else{
            AButton.texture = SKTexture(imageNamed: "flatDark35")
        }
    }
    
    func showRestartMenu(){
        let node = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        node.text = "GameOver"
        node.position = CGPoint(x: 0, y: 80)
        node.fontSize = 60
        node.zPosition = CGFloat(ZPositions.button.rawValue)
        self.parent!.addChild(node)
        self.parent!.addChild(restartButton)
        self.parent!.addChild(backButton)
    }
    
    func showClearMenu(){
        
    }
    
    func setupHeartDisplay(maxLife:Int){
        for i in 0...maxLife-1{
            let heart = Heart(imageNamed:"hudHeart_full")
            heart.position = CGPoint(x: -cameraOrigin.x + CGFloat(30*(i+1)), y: cameraOrigin.y - 30)
            heart.id = i
            self.parent!.addChild(heart)
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
    
    func showDamageLabel(position:CGPoint,damage:Int){
        let text = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        text.text = String(damage)
        text.position = CGPoint(x: position.x, y: position.y + 20)
        text.fontSize = 60
        text.zPosition = CGFloat(ZPositions.otherNodes.rawValue)
        
        self.scene!.addChild(text)
        
        let fadeout = SKAction.fadeOut(withDuration: 1)
        
        let remove = SKAction.run {
            text.removeFromParent()
        }
        
        text.run(SKAction.sequence([fadeout,remove]))
    }
}
