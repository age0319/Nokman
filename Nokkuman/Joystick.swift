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
    
    var xValue:CGFloat = 0
    var yValue:CGFloat = 0
    
    var joystickAction: ((_ x: CGFloat) -> ())?
    
    override init() {
        
        let joystickRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let joystickPath = UIBezierPath(ovalIn: joystickRect)
        
        joystick = SKShapeNode(path: joystickPath.cgPath, centered: true)
        joystick.fillColor = UIColor.gray
        joystick.strokeColor = UIColor.clear
        
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
        // タッチ地点の補正をする。
        let x = p.x.clamped(-maxRange, maxRange)
        // スティックの位置を変える
        stick.position = CGPoint(x: x, y: 0)

        if let joystickAction = joystickAction{
            joystickAction(x)
        }
        
    }
    
    func resetStick(){
        stick.position = CGPoint(x: 0, y: 0)
    }
}

extension CGFloat{
    //タッチ地点が最小値よりも小さければ最小値を、タッチ地点が最大値よりも大きければ最大値を返す
    func clamped(_ min:CGFloat,_ max: CGFloat) -> CGFloat{
        return self < min ? min : (self > max ? max: self)
    }
}
