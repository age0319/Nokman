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
    
    init(stage:String){
        
        var fileNames:[String] = []
        
        if stage == "stage1"{
            fileNames = ["EncounterA","EncounterB","EncounterC","EncounterD","EncounterE","EncounterF","EncounterG"]
        } else if stage == "stage2"{
            fileNames = ["EncounterH","EncounterI","EncounterJ","EncounterK","EncounterL","EncounterM","EncounterN"]
        }
        
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
