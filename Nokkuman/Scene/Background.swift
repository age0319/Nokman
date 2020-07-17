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
    let initialSize = CGSize(width: 812, height: 375)
    init(){
        super.init(texture: SKTexture(imageNamed: "Cartoon_Forest_BG_01"), color: .clear, size: initialSize)
        self.zPosition = CGFloat(ZPositions.background.rawValue)
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }

}
