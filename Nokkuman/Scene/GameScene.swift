//
//  GameScene.swift
//  Nokkuman
//
//  Created by haru on 2020/07/08.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    let nokman = Nokman()
    let cam = SKCameraNode()
        
    override func didMove(to view: SKView) {

        self.anchorPoint = .zero
        
        print(self.size)
        
        // プレイヤーをセット
        self.addChild(nokman)
        
        // カメラをセット
        self.camera = cam
        self.addChild(cam)
        
        // ボタンをセット
        setupButtons()
        
        // エンカウンターをセット
        setupEncounters()
        
        self.physicsWorld.contactDelegate = self
    }
        
    var nodesToRemove = [SKNode]()
    
    func didBegin(_ contact: SKPhysicsContact) {
        var one:SKPhysicsBody = SKPhysicsBody()
        var two:SKPhysicsBody = SKPhysicsBody()
        var player:Bool = false
    
        let nokmanMask = PhysicsCategory.nokman.rawValue | PhysicsCategory.damagedNokman.rawValue
        
        let bulletMask = PhysicsCategory.bullet.rawValue
        
        if (contact.bodyA.categoryBitMask & nokmanMask) > 0 {
            one = contact.bodyA
            two = contact.bodyB
            player = true
        }else if(contact.bodyB.categoryBitMask & nokmanMask > 0){
            one = contact.bodyB
            two = contact.bodyA
            player = true
        }else if (contact.bodyA.categoryBitMask & bulletMask) > 0 {
            one = contact.bodyA
            two = contact.bodyB
        }else if(contact.bodyB.categoryBitMask & bulletMask > 0){
            one = contact.bodyB
            two = contact.bodyA
        }
        
        if player {
            switch two.categoryBitMask {
            case PhysicsCategory.ground.rawValue:
                print("hit the ground")
            case PhysicsCategory.enemy.rawValue:
                print("hit the enemy")
            case PhysicsCategory.box.rawValue:
                print("hit the box")
            default:
                print("No game logic.")
            }
        }else{
            switch two.categoryBitMask {
            case PhysicsCategory.enemy.rawValue:
                nodesToRemove.append(one.node!)
                nodesToRemove.append(two.node!)
                print("bullet hit the enemy")
            case PhysicsCategory.box.rawValue:
                print("bullet hit the box")
            default:
                print("No game logic.")
            }
        }
    }
    
    override func didFinishUpdate()
    {
        nodesToRemove.forEach(){$0.removeFromParent()}
        nodesToRemove = [SKNode]()
    }
    
    func setupEncounters(){
        let em = EncounterManager()
        for i in 0..<em.encounters.count{
            let node:SKNode = em.encounters[i]
            node.position = CGPoint(x: Int(self.size.width)*i,y: 0)
            self.addChild(node)
        }
    }
    
    override func didSimulatePhysics() {
        //横スクロールゲームのため、高さは固定でx座標だけ動けば良い。
        self.camera?.position = CGPoint(x: self.nokman.position.x, y:0)
    }
    
    func setupButtons(){
        // カメラに追随して動くようにボタンはカメラの子として設置する。
        // カメラ(SKCameraNode)の開始座標はフレームの中心。
        // 開始座標を左下にするためにフレームの中心座標を引く。
        
        let buttonSize = CGSize(width: 60, height: 60)
        
        let cameraOrigin = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        // 左ボタンをセット
        let leftMove = SKSpriteNode(imageNamed: "flatDark23")
        
        leftMove.size = buttonSize
        
        leftMove.position = CGPoint(x: -cameraOrigin.x + 60, y: -cameraOrigin.y + 30)
        
        leftMove.name = "Left"
        
        leftMove.zPosition = CGFloat(ZPositions.button.rawValue)
        
        cam.addChild(leftMove)
        
        //　右ボタンをセット
        let rightMove = SKSpriteNode(imageNamed: "flatDark24")
        
        rightMove.size = buttonSize
        
        rightMove.position = CGPoint(x: -cameraOrigin.x + 150, y: -cameraOrigin.y + 30)
        
        rightMove.name = "Right"
        
        rightMove.zPosition = CGFloat(ZPositions.button.rawValue)

        cam.addChild(rightMove)
        
        // ジャンプボタンをセット
        let jump = SKSpriteNode(imageNamed: "flatDark25")
        
        jump.size = buttonSize
               
        jump.position = CGPoint(x: cameraOrigin.x - 150, y: -cameraOrigin.y + 30)
        
        jump.zPosition = CGFloat(ZPositions.button.rawValue)

        jump.name = "Jump"
        
        cam.addChild(jump)
        
        // ジャンプボタンをセット
        let fire = SKSpriteNode(imageNamed: "flatDark35")
        
        fire.size = buttonSize
        
        fire.position = CGPoint(x: cameraOrigin.x - 60, y: -cameraOrigin.y + 30)
        
        fire.zPosition = CGFloat(ZPositions.button.rawValue)
        
        fire.name = "Fire"
        
        cam.addChild(fire)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチしたボタンによって処理を分ける
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if (node.name == "Left") {
                self.nokman.Run(bw:true)
            } else if (node.name == "Right") {
                self.nokman.Run(bw:false)
            } else if ( node.name == "Jump") {
                self.nokman.jumping = true
            } else if ( node.name == "Fire"){
                self.nokman.firing = true
            }
        }
    }
    
    func shot(){
        let shot = Shot(pos: self.nokman.position, bw:self.nokman.backward)
        self.addChild(shot)
        shot.fire()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name == "Left" {
                self.nokman.leftMoving = false
                self.nokman.Idle()
            } else if node.name == "Right" {
                self.nokman.rightMoving = false
                self.nokman.Idle()
            } else if node.name == "Jump" {
                self.nokman.jumping = false
            } else if node.name == "Fire" {
                self.nokman.firing = false
            }
        }
    }
    
    var jumpTime:Double = 0
    var jumpInterval:Double = 0.8
    
    var fireTime:Double = 0
    var fireInterval:Double = 0.1
    
    override func update(_ currentTime: TimeInterval) {
        
        nokman.update(currentTime)
        
        //　ジャンプフラグが立っていなければ終了
        if self.nokman.jumping {
            // インターバルを空けないとジャンプできないようにする
            if jumpTime == 0 || currentTime - jumpTime > jumpInterval {
                self.nokman.Jump()
                jumpTime = currentTime
            }
        }
        
        if self.nokman.firing {
            // インターバルを空けないと発砲できないようにする
            if fireTime == 0 || currentTime - fireTime > fireInterval {
                self.nokman.Fire()
                shot()
                fireTime = currentTime
            }
        }
    }
   
}
