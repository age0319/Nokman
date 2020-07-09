//
//  GameScene.swift
//  Nokkuman
//
//  Created by haru on 2020/07/08.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let nokkuman = Nokkuman()
    let joystick = Joystick()
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        self.addChild(nokkuman)
        self.addChild(joystick)
        
        //ゲームシーンにも物理エンジンを設定。フレームの隅に行くと折り返す。
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        joystick.moveStick(touch: touches.first!)
        
        joystick.joystickAction = { (x: CGFloat ) in
            // スティックの位置によって速度と向きを変える。
            if 0 < x {
                self.nokkuman.physicsBody?.velocity = CGVector(dx: 100, dy: 0)
                self.nokkuman.FlipDirection(forward: true)
            } else {
                self.nokkuman.physicsBody?.velocity = CGVector(dx: -100, dy: 0)
                self.nokkuman.FlipDirection(forward: false)
            }
        }
        self.nokkuman.startRunAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 指が離れたスティックを初期化してキャラクタを止める
        joystick.resetStick()
        self.nokkuman.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
        self.nokkuman.FlipDirection(forward: true)
        self.nokkuman.startIdleAnimation()
    }
}
