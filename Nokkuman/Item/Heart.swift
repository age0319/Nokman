//
//  Heart.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/19.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class Heart:SKSpriteNode{
    var id = Int()
    let heartSize = CGSize(width: 30, height: 30)
    
    init(imageNamed:String){
        super.init(texture: SKTexture(imageNamed: imageNamed), color: .clear, size: heartSize)
        self.zPosition = CGFloat(ZPositions.button.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Fill(){
        self.texture = SKTexture(imageNamed: "hudHeart_full")
    }
    
    func Empty(){
        self.texture = SKTexture(imageNamed: "hudHeart_empty")
    }
}
