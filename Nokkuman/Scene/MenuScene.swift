//
//  MenuScene.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/27.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチしたボタンによって処理を分ける
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
          
            if ( node.name == "start"){
                let scene = SKScene(fileNamed: "StageSelect")
                scene!.scaleMode = .aspectFit
                self.view?.presentScene(scene)
            }
        }
    }
}
