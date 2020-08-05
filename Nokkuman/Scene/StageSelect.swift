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
    
    var flags = [Flag]()
    
    override func didMove(to view: SKView) {
 
        if let scene = SKScene(fileNamed: "StageSelect"){
            for child in scene.children{
                let sprite = type(of: child).init()
                sprite.position = child.position
                sprite.name = child.name
                if let flag = sprite as? Flag{
                    self.addChild(flag)
                    flags.append(flag)
                }
            }
        }
        
        for flag in flags{
            flag.changeFlagColor()
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチしたボタンによって処理を分ける
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            let scene = GameScene(size: self.size)
            
            if node.name == "stage1"{
                scene.stage = 1
                self.view?.presentScene(scene)
            }else if node.name == "stage2"{
                scene.stage = 2
                self.view?.presentScene(scene)
            }else if node.name == "stage3"{
                scene.stage = 3
                self.view?.presentScene(scene)
            }else if node.name == "exit"{
                for flag in flags{
                    SaveData().save(key: flag.name!, value: false)
                    flag.changeFlagColor()
                }
            }
            
        }
    }
}
