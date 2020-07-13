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
    func createBackgound(frameSize:CGSize,num:Int){
        var i = 0
        while i < num {
            let bg = SKSpriteNode(imageNamed: "Cartoon_Forest_BG_01")
            bg.position = CGPoint(x: CGFloat(i) * frameSize.width,y: 0)
            bg.size = frameSize
            self.addChild(bg)
            i += 1
        }
    }
}
