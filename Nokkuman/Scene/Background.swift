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
    init(frameSize:CGSize){
        super.init(texture: SKTexture(imageNamed: "Cartoon_Forest_BG_01"), color: .clear, size: frameSize)
        self.zPosition = CGFloat(ZPositions.background.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
