//
//  Settings.swift
//  Nokkuman
//
//  Created by 上松晴信 on 2020/07/16.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit

enum ZPositions: Int {
    case background
    case foreground
    case player
    case otherNodes
    case button
}

enum PhysicsCategory: UInt32{
    case nokman = 1
    case ground = 2
    case enemy = 4
    case box = 8
    case bullet = 16
    case spike = 32
    case exit = 64
    case fireball = 128
}

class Settings {
    var fileNames = [String]()
    var stageNumber = Int()
    init(stage:Int){
        if stage == 1{
            fileNames = ["EncounterA","EncounterB","EncounterC","EncounterD","EncounterE","EncounterF","AlienGreen"]
        } else if stage == 2{
            fileNames = ["EncounterH","EncounterI","EncounterJ","HeartStage","EncounterA","EncounterB","AlienPink"]
        } else if stage == 3{
            fileNames = ["EncounterC","EncounterD","HeartStage","EncounterA","EncounterE","EncounterH","AlienBlue"]
        }
        stageNumber = fileNames.count
    }
}
