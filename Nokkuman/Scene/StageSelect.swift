//
//  StageSelect.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/28.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

class StageSelect: SKScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチしたボタンによって処理を分ける
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)

            if let name = node.name{
                let scene = GameScene(size: self.size)
                scene.stage = name
                self.view?.presentScene(scene, transition: .crossFade(withDuration: 0.6))
            }
        }
    }
}
