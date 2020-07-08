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
        
        //主人公に物理エンジンを与えて速度を付与できるようにする
        nokkuman.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        nokkuman.physicsBody?.mass = 1
        self.addChild(nokkuman)
        
        // ジョイスティックの位置を設定
        joystick.position = CGPoint(x: 100, y: 100)
        self.addChild(joystick)
        
        //ゲームシーンにも物理エンジンを設定。フレームの隅に行くと折り返す。
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        joystick.moveStick(touch: touches.first!)
        
        joystick.joystickAction = { (x: CGFloat ) in
            // スティックの位置によって速度を変える。
            if 0 < x && x < 10 {
                self.nokkuman.physicsBody?.velocity = CGVector(dx: 50, dy: 0)
            }else if 10 < x && x < 20 {
                 self.nokkuman.physicsBody?.velocity = CGVector(dx: 100, dy: 0)
            }else if -10 < x && x < 0 {
                 self.nokkuman.physicsBody?.velocity = CGVector(dx: -50, dy: 0)
            }else if -20 < x && x < -10 {
                 self.nokkuman.physicsBody?.velocity = CGVector(dx: -100, dy: 0)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 指が離れたスティックを初期化して、キャラクタを止める
        joystick.resetStick()
        self.nokkuman.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
    }
}
