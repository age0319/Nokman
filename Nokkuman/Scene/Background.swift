//
//  Background.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/13.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class Background:  SKSpriteNode{
        
    func craeteBackground(frameSize:CGSize, number:Int,stage:String){
    
        let initialSize = frameSize
        var filename = ""
        
        if stage == "stage1"{
            filename = "Cartoon_Forest_BG_01"
        }else if stage == "stage2"{
            filename = "Cartoon_Forest_BG_02"
        }else if stage == "stage3"{
            filename = "Cartoon_Forest_BG_03"
        }
        
        for i in 0..<number{
            let bg = SKSpriteNode(texture: SKTexture(imageNamed: filename), color: .clear, size: initialSize)
            bg.position = CGPoint(x: CGFloat(i) * initialSize.width, y: 0)
            bg.zPosition = CGFloat(ZPositions.background.rawValue)
            
            self.addChild(bg)
        }
        
        //左に壁を作る場合に利用する
//        let LeftUnderPoint = CGPoint(x: -frameSize.width/2, y: -frameSize.height/2)
//        let LeftTopPoint = CGPoint(x: -frameSize.width/2, y: frameSize.height/2)
//
//        self.physicsBody = SKPhysicsBody(edgeFrom: LeftUnderPoint, to: LeftTopPoint)
    }
}
