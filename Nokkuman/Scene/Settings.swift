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
    case damagedNokman = 2
    case ground = 4
    case enemy = 8
    case bullet = 16
    case box = 32
}
