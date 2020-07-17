//
//  EncounterManager.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/15.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import SpriteKit

class EncounterManager {
    
    var encounters:[SKNode] = []
    
    init(){
        
        let fileNames = ["EncounterA","EncounterB","EncounterC"]
        
        for f in fileNames{
            if let scene = SKScene(fileNamed: f){
                let encounterNode = SKNode()
                for child in scene.children{
                    let node = type(of: child).init()
                    node.position = child.position
                    node.name = child.name
                    encounterNode.addChild(node)
                }
                encounters.append(encounterNode)
            }
        }
    }    
    
}
