//
//  Joystick.swift
//  Nokkuman
//
//  Created by haru on 2020/07/08.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import SpriteKit


class Joystick: SKNode {
    var joystick = SKShapeNode()
    var stick = SKShapeNode()
    
    let maxRange:CGFloat = 20
    
    var joystickAction: ((_ x: CGFloat) -> ())?
    
    override init() {
        
        // 外側の円の作成
        // 四角形の大きさを決める
        let joystickRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        // ovalInを指定すると円を作成する
        let joystickPath = UIBezierPath(ovalIn: joystickRect)
        
        joystick = SKShapeNode(path: joystickPath.cgPath, centered: true)
        joystick.fillColor = UIColor.gray
        joystick.strokeColor = UIColor.clear
        
        // 内側の円（スティック）の作成
        let stickRect = CGRect(x: 0, y: 0, width: 40, height: 40)
        let stickPath = UIBezierPath(ovalIn: stickRect)
        
        stick = SKShapeNode(path: stickPath.cgPath, centered: true)
        stick.fillColor = UIColor.black
        stick.strokeColor = UIColor.white
        
        super.init()
        
        addChild(joystick)
        addChild(stick)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveStick(touch: UITouch){
        
        // タッチ地点を取得する
        let p = touch.location(in: self)
                
        // ジョイスティックが操作されたら
        if -maxRange < p.x && p.x < maxRange {
            // スティックを倒す
            stick.position = CGPoint(x: p.x, y: 0)

            // キャラクタを移動させる
            if let joystickAction = joystickAction{
                joystickAction(p.x)
            }
        }
    }
    
    func resetStick(){
        stick.position = CGPoint(x: 0, y: 0)
    }
}

