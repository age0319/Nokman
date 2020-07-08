//
//  Nokkuman.swift
//  Nokkuman
//
//  Created by haru on 2020/07/08.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import SpriteKit

class Nokkuman :SKSpriteNode{
    // SKTextureで画像を指定します。
    let mytexture = SKTexture(imageNamed: "2_entity_000_IDLE_000")
    // キャラクターのサイズを指定します。
    let initialSize = CGSize(width: 64, height: 64)
    // キャラクターの位置を指定します。
    let initialPosition = CGPoint(x: 100, y: 100)
    
    init() {
        super.init(texture: mytexture, color: .clear, size: initialSize)
        self.position = initialPosition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
