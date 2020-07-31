//
//  Frog.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/15.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class Frog:Enemy {
    
    let initialSize = CGSize(width: 42, height: 42)
    let frog_images = ["frog","frog_move","frog_dead"]
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        images = frog_images
        createMoveAnimation()
        createDieAnimation()
        self.run(animationAndMove)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
