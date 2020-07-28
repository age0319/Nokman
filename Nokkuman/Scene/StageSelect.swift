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
          
            if ( node.name == "stage1" ){
                let scene = GameScene(size: self.size)
                scene.stage = "stage1"
                self.view?.presentScene(scene, transition: .crossFade(withDuration: 0.6))
            } else if ( node.name == "stage2"){
                print("stage2")
            } else if ( node.name == "stage3"){
                print("stage3")
            }
        }
    }
}
